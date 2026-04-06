class NowplayingCli < Formula
  desc "Retrieves currently playing media, and simulates media actions"
  homepage "https://github.com/kirtan-shah/nowplaying-cli"
  url "https://ghfast.top/https://github.com/kirtan-shah/nowplaying-cli/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "a495a4f6dfc75326d4ab8843c82f8b0e42ac83d88c397461ea6b7968973da01d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87a38ee11003d4ba859f8dda0fc11fad58d38aa2b2688205fc44e3ce91a739f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d1803bd15ca30129407a4a6b6905475b823be4fde8302bb76ce5734f5905a9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5bcc94e36688dc8f326216284d7961b68170dea873ffd778763ee19621b9450"
    sha256 cellar: :any_skip_relocation, sonoma:        "976e8a7cce5bb8e2f848e698df4056b0c2315fff5dcbdef6891a90affdb4bc15"
  end

  depends_on :macos

  def install
    system "make"
    bin.install "nowplaying-cli"
  end

  test do
    assert_match "{", shell_output("#{bin}/nowplaying-cli get-raw")
  end
end