cask "forkgram-telegram" do
  arch arm: "arm64", intel: "x86"

  version "4.11.3"
  sha256 arm:   "026f2a6da334d7812e8d4591d722c67d496d3ac2084164715ac06a73bb76adf0",
         intel: "0621c6d1ade2d15275fbca481fcbf0d741a17d842bf3545185992d044747c68e"

  url "https://ghproxy.com/https://github.com/Forkgram/tdesktop/releases/download/v#{version}/Forkgram.macOS.no.auto-update_#{arch}.zip"
  name "Forkgram"
  desc "Fork of Telegram Desktop"
  homepage "https://github.com/Forkgram/"

  # NOTE: This approach involves multiple requests and should be avoided
  # whenever possible. If upstream starts reliably providing the macOS zip
  # files in every release, we should switch to `url :url` with
  # `strategy :github_latest`.
  livecheck do
    url "https://github.com/Forkgram/tdesktop/releases?q=prerelease%3Afalse"
    regex(%r{/v?(\d+(?:\.\d+)+)/Forkgram[._-]macOS[._-][^"' >]*?#{arch}\.zip}i)
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

  # Renamed to avoid conflict with telegram
  app "Telegram.app", target: "Forkgram.app"

  zap trash: "~/Library/Application Support/Forkgram Desktop"
end