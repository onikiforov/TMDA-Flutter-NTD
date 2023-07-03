import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:tmda/core/util/assets_manager.dart';
import 'package:tmda/core/util/color_manager.dart';
import 'package:tmda/core/util/enums.dart';
import 'package:tmda/core/widgets/neon_light_painter.dart';
import 'package:tmda/features/auth/presentation/widgets/no_connection.dart';
import 'package:tmda/features/search/presentation/bloc/search_bloc.dart';
import 'package:tmda/features/search/presentation/components/custom_search_field.dart';
import 'package:tmda/features/search/presentation/components/movie_search_component.dart';
import 'package:tmda/features/search/presentation/components/people_search_component.dart';
import 'package:tmda/features/search/presentation/components/search_body.dart';
import 'package:tmda/features/search/presentation/components/tv_shows_search_component.dart';
import 'package:tmda/injection_container.dart';

@RoutePage()
class SearchScreen extends StatefulWidget with AutoRouteWrapper {
  const SearchScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchBloc>(),
      child: this,
    );
  }

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  late TextEditingController _textEditingController;
  late TabController _tabController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Stack(
          children: [
            const Positioned(
              top: 30,
              left: 20,
              child: NeonLightPainter(
                color: ColorsManager.primaryColor,
              ),
            ),
            const Positioned(
              bottom: 350,
              right: 0,
              child: NeonLightPainter(color: ColorsManager.secondaryColor),
            ),
            const Positioned(
              bottom: 10,
              left: 10,
              child: NeonLightPainter(color: ColorsManager.primaryColor),
            ),
            Positioned.fill(
              top: 180,
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  switch (state.searchState) {
                    case BlocState.initial:
                      return const SearchBody();
                    case BlocState.loading:
                      return Center(
                        child: Lottie.asset(AssetsManager.neonLoading),
                      );
                    case BlocState.success:
                      return IndexedStack(
                        index: state.tabIndex,
                        children: [
                          Visibility(
                            maintainState: true,
                            visible: state.tabIndex == 0 ? true : false,
                            child:  MoviesSearchComponent(
                                searchInput: _textEditingController.text
                            ),
                          ),
                          Visibility(
                            maintainState: true,
                              visible: state.tabIndex == 1 ? true : false,
                              child: TvShowsSearchComponent(
                                searchInput: _textEditingController.text,
                              ),
                          ),
                          Visibility(
                            maintainState: true,
                            visible: state.tabIndex == 2 ? true : false,
                            child: PeopleSearchComponent(searchInput: _textEditingController.text),
                          ),
                        ],
                      );
                    case BlocState.failure:
                      return NoConnection(
                        onTap: () {
                          context.read<SearchBloc>()
                            ..add(SearchForMovieEvent(_textEditingController.text))
                            ..add(SearchForTvShowEvent(_textEditingController.text))
                            ..add(SearchForPersonEvent(_textEditingController.text));
                        },
                      );
                  }
                },
              ),
            ),
            Positioned.fill(
              top: 60,
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24).r,
                child: Column(
                  children: [
                    CustomSearchField(
                      textEditingController: _textEditingController,
                      onChanged: (searchText) {
                        context.read<SearchBloc>()
                          ..add(SearchForMovieEvent(searchText))
                          ..add(SearchForTvShowEvent(searchText))
                          ..add(SearchForPersonEvent(searchText));
                      },
                    ),
                    SizedBox(height: 18.h),
                    TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      controller: _tabController,
                      indicatorPadding: const EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8).r,
                      labelStyle: Theme.of(context).textTheme.bodyLarge,
                      indicator: ShapeDecoration(
                          color: ColorsManager.darkPrimary,
                          shape: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(40),
                          ),
                      ),
                      tabs: const [
                        Tab(text: 'Movies'),
                        Tab(text: 'Tv Shows'),
                        Tab(text: 'People',)
                      ],
                      onTap: (value) {
                        BlocProvider.of<SearchBloc>(context).add(ChangeSearchTabEvent(_tabController.index));
                        _tabController.animateTo(_tabController.index);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
