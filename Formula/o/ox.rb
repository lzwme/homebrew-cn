class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.7.2.tar.gz"
  sha256 "6ddcfb008f7cc86c9074dc46302f47f2763a13aea0765c00d6e9f4731d8556d2"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7abca35692db07006cfdc2bd9312f3a937b07e9651ffc8694a9b368f22bc38e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baef0f01cf869fdaa47f01f23d1ece49a5444ff86dbdfccd5d77850f1bc50125"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05a6ba32c30d776496dc94115b4978e4da0bacc9ed85b6db8844d3bc77fec01d"
    sha256 cellar: :any_skip_relocation, sonoma:        "648bbe305252eedb6cb8155412e88b9d63bd540b3b5b216a61177a1edaf094e5"
    sha256 cellar: :any_skip_relocation, ventura:       "c5c304b3d46e7efc6e7a9d6e235bf227c08a681bb718b249f307189a37b233d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28ddc6e09bfca415cbee588648ffaa14e49bc8e65bf4f6fb38db370ba2998bc9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ox is a TUI application, hard to test in CI
    # see https:github.comcurlpipeoxissues178 for discussions
    assert_match version.to_s, shell_output("#{bin}ox --version")
  end
end