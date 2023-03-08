cask "alex313031-thorium" do
  arch arm: "arm64", intel: "x64"

  version "M109.0.5414.120-2"
  sha256 arm:   "1d49f062c8806b282aadec0504bc7b756a2805c82cae41e675206acfae198610",
         intel: "d4ec6db1cd028041166dacb3a121406ce1619ebd965073600f9e43206b42f92b"

  url "https://ghproxy.com/https://github.com/Alex313031/Thorium-Special/releases/download/#{version}/Thorium_MacOS_#{arch}.dmg",
      verified: "github.com/Alex313031/Thorium-Special/"
  name "Thorium"
  desc "Web browser"
  homepage "https://thorium.rocks/"

  # NOTE: This approach involves multiple requests and should be avoided
  # whenever possible. If upstream starts reliably providing dmg files in every
  # release, we should switch to `url :url` with `strategy :github_latest`.
  livecheck do
    url "https://github.com/Alex313031/Thorium-Special/releases?q=prerelease%3Afalse"
    regex(%r{/([^/]+?)/Thorium[._-]MacOS[._-]#{arch}\.dmg}i)
    strategy :page_match do |page, regex|
      # Collect the release tags on the page
      tags = page.scan(%r{href=["']?[^"' >]*?/releases/tag/([^"' >]*?)["' >]}i)&.flatten&.uniq

      max_reqs = 4
      tags.each_with_index do |tag, i|
        break if i >= max_reqs

        # Fetch the assets list HTML for the tag and match within it
        assets_page = Homebrew::Livecheck::Strategy.page_content(
          @url.sub(%r{/releases/?.+}, "/releases/expanded_assets/#{tag}"),
        )
        matches = assets_page[:content]&.scan(regex)&.map { |match| match[0] }

        break matches if matches.present?
      end
    end
  end

  conflicts_with cask: "thorium"

  app "Thorium.app"

  zap trash: [
    "~/Library/Application Support/Thorium",
    "~/Library/Caches/Thorium",
    "~/Library/Preferences/org.chromium.Thorium.plist",
    "~/Library/Saved Application State/org.chromium.Thorium.savedState",
  ]
end