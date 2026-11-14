import 'dart:math' as math;

import '../models.dart';

/// モックユーザーは「anchor（中心点）からの相対距離」で配置する。
/// anchor には実 GPS で取得した現在地が入り、どこにいても近くの音とも候補が並ぶ。
class _MockSpec {
  final String id;
  final String nickname;
  final String decade;
  final String gender;
  final String iconCategoryId;
  final List<String> interestIds;
  final String bio;
  final double northKm; // anchor からの北方向距離
  final double eastKm; // anchor からの東方向距離

  const _MockSpec(this.id, this.nickname, this.decade, this.gender,
      this.iconCategoryId, this.interestIds, this.bio, this.northKm,
      this.eastKm);
}

const List<_MockSpec> _specs = [
  _MockSpec(
    'u-guitar-ken',
    'ギターのけん',
    '30代',
    'male',
    'guitar',
    ['guitar', 'band', 'jpop'],
    'テレキャビ type を弾いています。週末は仲間とセッションしています。',
    0.6,
    0.2,
  ),
  _MockSpec(
    'u-bass-akira',
    'ベースのあきら',
    '40代',
    'male',
    'bass',
    ['bass', 'band', 'jazz'],
    'ジャズベース歴20年。歩くベースラインと呼ばれています。',
    -0.3,
    -0.1,
  ),
  _MockSpec(
    'u-drums-nana',
    'ドラムのなな',
    '20代',
    'female',
    'drums',
    ['drums', 'band', 'anime'],
    'アニソンコピーからオリジナルまで。メトロノームと友達です。',
    0.15,
    -0.4,
  ),
  _MockSpec(
    'u-vocal-sora',
    '歌うのが好きなそら',
    '20代',
    'undisclosed',
    'vocal',
    ['vocal', 'karaoke', 'jpop'],
    'カラオケで鍛えた地声高音ボイスです。一緒に歌える人を探しています。',
    -0.7,
    0.5,
  ),
  _MockSpec(
    'u-dtm-miu',
    'DTMのみう',
    '20代',
    'female',
    'dtm',
    ['dtm', 'anime', 'vocal'],
    'ボカロ曲を作っています。歌ってくれる方を動画・生どちらでも募集。',
    1.2,
    -0.9,
  ),
  _MockSpec(
    'u-jazz-kei',
    'ジャズ喫茶のけい',
    '30代',
    'undisclosed',
    'jazz',
    ['jazz', 'classic', 'live'],
    'モダンジャズにはまっています。ライブの通りすがり参戦もよくやります。',
    -1.1,
    1.0,
  ),
  _MockSpec(
    'u-classic-hina',
    'ピアノのひな',
    '30代',
    'female',
    'classic',
    ['classic', 'jazz', 'piano'],
    'ピアノ歴15年。連弾の相手を探しています。あわせてくれます。',
    0.9,
    0.35,
  ),
  _MockSpec(
    'u-live-kyo',
    '参戦担当のきょう',
    '40代',
    'male',
    'live',
    ['live', 'jpop', 'photo'],
    '週3でライブハウスに通っています。参戦仲間・1人参戦歓迎です。',
    0.45,
    -1.3,
  ),
];

class _BusinessSpec {
  final String id;
  final String nickname;
  final String iconCategoryId;
  final String storeType;
  final String bio;
  final double northKm;
  final double eastKm;

  const _BusinessSpec(this.id, this.nickname, this.iconCategoryId,
      this.storeType, this.bio, this.northKm, this.eastKm);
}

const List<_BusinessSpec> _businessSpecs = [
  _BusinessSpec(
    'b-live-cycles',
    'ライブハウス サイクルズ',
    'guitar',
    'ライブハウス',
    'オールジャンルのライブを毎日やっています。機材持ち込みも歓迎。',
    0.8,
    0.9,
  ),
  _BusinessSpec(
    'b-studio-note',
    '音楽スタジオ ノート',
    'drums',
    '音楽スタジオ',
    '防音個室8部屋。ドラムセット常設。深夜枠も割引があります。',
    -0.5,
    1.1,
  ),
  _BusinessSpec(
    'b-shop-frets',
    '楽器店 フレッツ',
    'bass',
    '楽器店',
    '中古ギター・ベースの買取りと販売。無料査定と簡易メンテもやっています。',
    1.5,
    -0.6,
  ),
  _BusinessSpec(
    'b-record-groove',
    'レコード屋 グルーヴ',
    'jazz',
    'レコード・CD・楽譜店',
    'ジャズ・ソウルのアナログ盤が豊富。試聴機もどうぞ。イベントも不定期開催。',
    -1.4,
    -0.8,
  ),
];

const double _kmPerDegLat = 111.32;

AppUser _specToUser(_MockSpec s, double anchorLat, double anchorLng) {
  final cos =
      math.cos(anchorLat * math.pi / 180.0).abs().clamp(0.01, 1.0);
  return AppUser(
    id: s.id,
    nickname: s.nickname,
    decade: s.decade,
    gender: s.gender,
    iconCategoryId: s.iconCategoryId,
    interestIds: s.interestIds,
    bio: s.bio,
    lat: anchorLat + s.northKm / _kmPerDegLat,
    lng: anchorLng + s.eastKm / (_kmPerDegLat * cos),
  );
}

BusinessUser _specToBusiness(
    _BusinessSpec s, double anchorLat, double anchorLng) {
  final cos =
      math.cos(anchorLat * math.pi / 180.0).abs().clamp(0.01, 1.0);
  return BusinessUser(
    id: s.id,
    nickname: s.nickname,
    decade: '経営者',
    gender: 'undisclosed',
    iconCategoryId: s.iconCategoryId,
    interestIds: const [],
    bio: s.bio,
    lat: anchorLat + s.northKm / _kmPerDegLat,
    lng: anchorLng + s.eastKm / (_kmPerDegLat * cos),
    storeType: s.storeType,
  );
}

/// 現在地を中心にモックユーザー（一般 + ビジネス）を配置する。
List<AppUser> buildMockUsers(double anchorLat, double anchorLng) {
  return [
    for (final s in _specs) _specToUser(s, anchorLat, anchorLng),
    for (final s in _businessSpecs) _specToBusiness(s, anchorLat, anchorLng),
  ];
}

/// シード募集（起動時刻からの残り時間で作るので、いつ開いても「今から」感が出る）。
/// host は generalUsers（モック一般ユーザー）から id で引く。
List<Recruitment> seedRecruitments(DateTime now, List<AppUser> generalUsers) {
  Recruitment make({
    required String hostId,
    required String genreId,
    required String title,
    required String body,
    required String meetup,
    required int capacity,
    required int minutesLeft,
  }) {
    return Recruitment(
      id: 'r-$hostId',
      hostId: hostId,
      genreId: genreId,
      title: title,
      body: body,
      meetup: meetup,
      capacity: capacity,
      createdAt: now.subtract(const Duration(minutes: 15)),
      expiresAt: now.add(Duration(minutes: minutesLeft)),
      memberIds: [hostId],
    );
  }

  return [
    make(
      hostId: 'u-guitar-ken',
      genreId: 'session',
      title: '今からスタジオでセッションしませんか',
      body: '定番曲を順番に回すセッションです。お題は参加者で決めます。初心者も歓迎。',
      meetup: '音楽スタジオ ノート ロビー',
      capacity: 4,
      minutesLeft: 105,
    ),
    make(
      hostId: 'u-jazz-kei',
      genreId: 'session',
      title: '今夜、ジャズのスタンダードを合わせませんか',
      body: 'テナーサックス持ちです。リズム隊の方、ぜひお願いします。',
      meetup: '音楽スタジオ ノート Room3',
      capacity: 3,
      minutesLeft: 70,
    ),
    make(
      hostId: 'u-live-kyo',
      genreId: 'live',
      title: '今夜のライブ、同行しませんか',
      body: 'サイクルズで3バンド観る予定です。一緒に参戦する方を探しています。',
      meetup: 'ライブハウス サイクルズ 入口',
      capacity: 4,
      minutesLeft: 160,
    ),
    make(
      hostId: 'u-vocal-sora',
      genreId: 'live',
      title: 'カバーオフ会しませんか',
      body: 'J-POPのカバーを歌い合う会です。演奏できる方も歌だけの方も大歓迎。',
      meetup: 'レコード屋 グルーヴ イベントスペース',
      capacity: 2,
      minutesLeft: 95,
    ),
    make(
      hostId: 'u-dtm-miu',
      genreId: 'talk',
      title: 'DTM・作編曲の勉強会をやります',
      body: 'mixの相談や音作りを見せ合う会です。ボカルとのマッチングも。',
      meetup: 'カフェ（レコード屋 グルーヴ となり）',
      capacity: 4,
      minutesLeft: 130,
    ),
    make(
      hostId: 'u-drums-nana',
      genreId: 'talk',
      title: 'ドラム敲き放題の会、参加者募集',
      body: 'スタジオを2枠借りました。メトロノーム恐怖症の改善も手伝います。',
      meetup: '音楽スタジオ ノート Room1',
      capacity: 3,
      minutesLeft: 45,
    ),
  ];
}

/// ゆずりあい・交換のシード。anchor（現在地）からの相対距離で配置する。
/// id が 'cx-seed-' 始まりのものは GPS 更新のたびに再配置される
/// （AppState.applyGps を参照）。
class _ExchangeSeedSpec {
  final String id;
  final String posterId;
  final String kind;
  final String itemDescription;
  final String areaName;
  final String detail;
  final double northKm;
  final double eastKm;
  final Duration age;
  const _ExchangeSeedSpec(this.id, this.posterId, this.kind,
      this.itemDescription, this.areaName, this.detail, this.northKm,
      this.eastKm, this.age);
}

const List<_ExchangeSeedSpec> _exchangeSeedSpecs = [
  _ExchangeSeedSpec(
    'cx-seed-1',
    'u-drums-nana',
    'give',
    '電子ドラム用ペダル（使用済み・動作確認済み）',
    '音楽スタジオ ノート 周辺',
    'アップグレードで手元に余ったので、'
        '使ってくださる方にゆずります。手渡し前提です。',
    0.3,
    -0.6,
    Duration(hours: 2),
  ),
  _ExchangeSeedSpec(
    'cx-seed-2',
    'u-bass-akira',
    'wanted',
    'ポータブルオーディオインターフェースを探しています',
    '駅裏の駐車場 周辺',
    '弾き語り録音用の小さいものを探しています。不要機材との'
        '交換の対応も可能です。DMお待ちしています。',
    -0.2,
    0.8,
    Duration(hours: 5),
  ),
  _ExchangeSeedSpec(
    'cx-seed-3',
    'u-guitar-ken',
    'trade',
    'エフェクター（コーラス）と ディレイを交換します',
    '市役所裏の駐車場 周辺',
    '音作りが変わったので交換希望です。状態は写真で'
        '送ります。公共の駐車場で受け渡しできます。',
    -0.9,
    -0.3,
    Duration(hours: 26),
  ),
];

List<InstrumentExchange> buildSeedInstrumentExchanges(
    DateTime now, double anchorLat, double anchorLng) {
  final cos = (anchorLat * math.pi / 180.0).abs().clamp(0.01, 1.0);
  return [
    for (final s in _exchangeSeedSpecs)
      InstrumentExchange(
        id: s.id,
        posterId: s.posterId,
        kind: s.kind,
        itemDescription: s.itemDescription,
        areaName: s.areaName,
        detail: s.detail,
        lat: anchorLat + s.northKm / _kmPerDegLat,
        lng: anchorLng + s.eastKm / (_kmPerDegLat * cos),
        createdAt: now.subtract(s.age),
      ),
  ];
}

/// モックの返信候補（デモの自動応答に使う。本開発では Supabase Realtime に置換）
const List<String> mockReplies = [
  'よろしくお願いします！',
  '次のセッション、楽しみですね。',
  '先に着いてスタジオの受付を済ませておきますね。',
  '曲目は定番から決めましょうか。',
];

/// モックの応募メッセージ
const List<String> mockApplyMessages = [
  '参加したいです！音楽仲間を探していました。',
  '同じ楽器をやっているので嬉しいです。',
  'この近くのライブによく参戦しています。',
];
