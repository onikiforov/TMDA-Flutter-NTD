import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmda/features/tv/presentation/bloc/tv_details/tv_details_bloc.dart';
import 'package:tmda/features/tv/presentation/components/episode_card.dart';

class TvShowSeasons extends StatefulWidget {
  const TvShowSeasons({super.key, required this.tvShowId});
  final int tvShowId;
  @override
  State<TvShowSeasons> createState() => _TvShowSeasonsState();
}

class _TvShowSeasonsState extends State<TvShowSeasons>
    with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(
      length: context.read<TvDetailsBloc>().state.tvShowDetails.seasons.length,
      initialIndex: 0,
      vsync: this,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvDetailsBloc, TvDetailsState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TabBar(
                controller: tabController,
                isScrollable: true,
                tabs: List.generate(
                  tabController.length,
                  (index) => Tab(
                    text: state.tvShowDetails.seasons[index].seasonName,
                  ),
                ),
                onTap: (index) {
                  BlocProvider.of<TvDetailsBloc>(context)
                      .add(ChangeSeasonsTabsIndexEvent(tabController.index));
                  tabController.animateTo(tabController.index);
                },
              ),
            ),
            IndexedStack(
              index: state.seasonsTabIndex,
              children: List.generate(
                tabController.length,
                (index) => ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      state.allSeasonsEpisodes[state.seasonsTabIndex].length,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    if (state
                        .allSeasonsEpisodes[state.seasonsTabIndex].isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: EpisodeCard(
                          title: state.allSeasonsEpisodes[state.seasonsTabIndex][index].name,
                          episodeNumber: state.allSeasonsEpisodes[state.seasonsTabIndex][index].number,
                          posterPath: state.allSeasonsEpisodes[state.seasonsTabIndex][index].posterPath,
                          vote: state.allSeasonsEpisodes[state.seasonsTabIndex][index].voteAverage,
                          voteCount: state.allSeasonsEpisodes[state.seasonsTabIndex][index].voteCount,
                          airDate: state.allSeasonsEpisodes[state.seasonsTabIndex][index].airDate,
                          episodeDuration: state.allSeasonsEpisodes[state.seasonsTabIndex][index].runTime,
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'No Episodes yet',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}