class Flyscrape < Formula
  desc "Standalone and scriptable web scraper"
  homepage "https://flyscrape.com/"
  url "https://ghproxy.com/https://github.com/philippta/flyscrape/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "d8948f42d5dda41a4c8a051983efdcdb8bbdceab1fb62d96c55bd0cb6c606bdf"
  license "MPL-2.0"
  head "https://github.com/philippta/flyscrape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bf9d1e8ed41288db4f3818c8ee1ae3cc76f5eb027ca0e9b46de01a57b961948"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "939d1dfe1c804250717922a9bb3cebe3b0e7c652cf46b8e7272be8bb3998470c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5a52a505465aec90fa0d8982a993e469a6f4497c08cb594831ac74ff9122f3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f682a628777eb59308b191708053918c931fa168d26b2c7e3a606497355a263"
    sha256 cellar: :any_skip_relocation, ventura:        "6e6cbf4faacc1379d6342ad58099a39494265009103baea630ba04fb7a36e52b"
    sha256 cellar: :any_skip_relocation, monterey:       "fd10d2e2d3bd08fab347f4497aaf998ae81abafbcac493221b59fa7936ec590f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f28755d5b3c8211eef7e424b2726e1b00f5db21dd9d9c270a2a49fb5b606d95"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite"

  def install
    tags = "osusergo,netgo,sqlite_omit_load_extension"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", tags, "./cmd/flyscrape"

    pkgshare.install "examples"
  end

  test do
    test_config = pkgshare/"examples/hackernews.js"
    return_status = OS.mac? ? 1 : 0
    output = shell_output("#{bin}/flyscrape run #{test_config} 2>&1", return_status)
    expected = if OS.mac?
      "unable to open database file"
    else
      "\"url\": \"https://news.ycombinator.com/\""
    end
    assert_match expected, output
  end
end