class Flyscrape < Formula
  desc "Standalone and scriptable web scraper"
  homepage "https://flyscrape.com/"
  url "https://ghproxy.com/https://github.com/philippta/flyscrape/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "4b76c981e565cb7347859f95efc9b960df526221cabad5a6e88c807dba6f7902"
  license "MPL-2.0"
  head "https://github.com/philippta/flyscrape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bcd7d6f11a88c254c69cbf76fc2855a1b9e706b975aaf60fa41f9aa007c09ec9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94284e404ca69256f46ebede6e83ce0abd253ca675ee8cac10106610b0db70d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce57482f030cd6ff6082d0b9f3e2054965889008dff7a835cfdf1409adabfbd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "85a14d4983f9fb0eceeb43618f757ffdcc5eaec79c15a538636778a6e46d61da"
    sha256 cellar: :any_skip_relocation, ventura:        "d979b60942c82b5b943e2777225512e662b15dc53f457bcb63b9d01df992d753"
    sha256 cellar: :any_skip_relocation, monterey:       "3f67b281d8f358c1eb86a319b35344f03bcb9ab84cfecdb50df5a403b69627d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d4647a23feef7163fe6ffdadc863032c5def6fbfe10312d8e7a9acb0ce197f3"
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