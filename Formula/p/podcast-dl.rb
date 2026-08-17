class PodcastDl < Formula
  desc "CLI for downloading and archiving podcasts"
  homepage "https://github.com/lightpohl/podcast-dl"
  url "https://registry.npmjs.org/podcast-dl/-/podcast-dl-12.1.3.tgz"
  sha256 "26b33010f7a1b4e6c47a74c0dca5c05c83ce5fc2b0f14fa014f3b22c0a57196d"
  license "MIT"
  head "https://github.com/lightpohl/podcast-dl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e8ea2151c878f8632a614cb8e7d7efb80002471902621cee10dd0c8b7871f536"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"feed.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <rss version="2.0">
        <channel>
          <title>Homebrew Test Podcast</title>
          <link>https://example.com/podcast</link>
          <description>Fixture for formula testing.</description>
          <item>
            <title>Episode One</title>
            <guid>episode-1</guid>
            <enclosure url="https://example.com/episode.mp3" type="audio/mpeg" length="1"/>
          </item>
        </channel>
      </rss>
    XML

    assert_match "Homebrew Test Podcast", shell_output("#{bin}/podcast-dl --file feed.xml --info")
  end
end