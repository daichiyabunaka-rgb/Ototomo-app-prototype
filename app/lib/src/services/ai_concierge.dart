import '../models.dart';

/// AI接客のデモ応答ロジック（プロトタイプ用のモック）。
/// 本開発では LLM API に置き換える。このロジックは店舗業態と
/// ユーザーの興味カテゴリからおすすめを案内する最低限のルールベース。
class AiConcierge {
  /// 最初の挨拶（店舗の口調 + ユーザーの興味を踏まえる）
  String greeting(AppUser me, BusinessUser store) {
    final interest = me.interestIds.isNotEmpty ? me.interestIds.first : null;
    final label = interest == null ? null : _categoryLabel(interest);
    final base = '${_opener(store)}'
        '${me.nickname}さん、${store.nickname}（${store.storeType}）のAI接客です。';
    if (label == null) {
      return '$base 楽器・ライブのことなら何でも聞いてください。';
    }
    return '$base $labelがお好みなんですね。'
        'うちの${_recommend(store)}がおすすめです。';
  }

  /// 店舗タイプごとの口調（本開発では LLM に店舗キャラ設定を渡して生成する）
  String _opener(BusinessUser store) {
    switch (store.storeType) {
      case 'ライブハウス':
        return 'いらっしゃい！演奏と鑑賞、どちらも大歓迎です。';
      case '音楽スタジオ':
        return 'いらっしゃいませ。防音個室をご案内できます。';
      case '楽器店':
        return 'いらっしゃい。楽器選びもお手伝いします。';
      case 'レコード・CD・楽譜店':
        return 'こんにちは。試聴機もありますよ。';
      case 'ライブカフェ・バー':
        return 'ようこそ。アコースティックライブの案内もできます。';
      default:
        return 'いらっしゃいませ。';
    }
  }

  /// ユーザー発話への応答
  String reply(String input, AppUser me, BusinessUser store) {
    final text = input.replaceAll(RegExp(r'\s'), '');
    if (text.contains('予約') || text.contains('来店') || text.contains('利用')) {
      return 'ありがとうございます。土日は混み合うため、'
          '平日の午前中でしたらゆっくりご案内できます。'
          'ご希望の時間をメモしておきますね。'
          '（デモのため実際の予約機能は本開発で提供します）';
    }
    if (text.contains('おすすめ') || text.contains('オススメ')) {
      return '今回は${_recommend(store)}がおすすめです。'
          '練習やライブの予定があれば教えてください。';
    }
    if (text.contains('ギター') || text.contains('ドラム') ||
        text.contains('楽器') || text.contains('機材')) {
      return '初めての方も歓迎しています。'
          'ご希望のスタイルに合わせて相談しながら選びます。';
    }
    if (text.contains('料金') || text.contains('いくら') ||
        text.contains('価格')) {
      return 'ご利用内容によって変わりますが、まずは一度お試しいただけます。'
          '詳しいプランは店舗ページをご確認ください（デモの固定値です）。';
    }
    if (text.contains('何時') || text.contains('営業時間')) {
      return '本日は10:00〜18:00で営業しております。'
          '混雑しやすいのは土曜午前です。（デモの固定値です）';
    }
    if (text.contains('駐車場') || text.contains('アクセス')) {
      return '近隣にコインパーキングがあります。'
          '大きな機材をお持ちの場合は事前にご相談ください。';
    }
    return '承知しました。「おすすめ」「料金」「営業時間」「予約」「楽器」など、'
        '気になることを聞いていただければ答えます。';
  }

  String _recommend(BusinessUser store) {
    switch (store.storeType) {
      case 'ライブハウス':
        return '平日のアコースティック枠';
      case '音楽スタジオ':
        return '平日深夜の割引枠';
      case '楽器店':
        return '中古ギター・ベースの整理セール品';
      case 'レコード・CD・楽譜店':
        return '今月のジャズ新譜コーナー';
      case 'ライブカフェ・バー':
        return '週末のミニライブとドリンクセット';
      default:
        return 'おすすめサービス';
    }
  }

  String _categoryLabel(String id) {
    const labels = {
      'guitar': 'ギター',
      'bass': 'ベース',
      'drums': 'ドラム・パーカッション',
      'vocal': 'ボーカル',
      'band': 'バンド活動',
      'jpop': 'J-POP・ロック',
      'anime': 'アニメ・ボカロ',
      'jazz': 'ジャズ',
      'classic': 'クラシック',
      'dtm': 'DTM・作曲',
      'live': 'ライブ参戦',
      'karaoke': 'カラオケ',
    };
    return labels[id] ?? '音楽のこと';
  }
}

/// グローバルインスタンス（本開発では DI / LLM API クライアントに置き換える）
final AiConcierge aiConcierge = AiConcierge();
