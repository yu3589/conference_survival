module ApplicationHelper
  def default_meta_tags(url: "https://res.cloudinary.com/dbar0jd0k/image/upload/v1751794356/conference_survival_top_jaj0mk.png")
    {
      site: "会議サバイバル診断",
      title: "会議サバイバル診断",
      reverse: true,
      charset: "utf-8",
      description: "会議中、意識も集中力も残りわずか…。そんな極限状態で試される、あなたの“会議サバイバルスキル”を診断します。",
      canonical: request.original_url,
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        image: url,
        locale: "ja-JP"
      },
        twitter: {
        card: "summary_large_image",
        image: url
      }
    }
  end
end
