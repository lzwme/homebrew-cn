class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.98.0.tar.gz"
  sha256 "290840ca37a0c855e65cd180c25fd8b6faf236c09c741f064f54b736a766c48b"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(^v?(0(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a088891a6cc4dd3946703591317ee1e4c488840203af619d1f2f76687eb299b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d418fe673f03591c5c40464ce32cc8cb8f2bd4b219210ebce2b25925337bd7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "924905d1a3c7ad76a8ee0c778469d68e8aa105d37c4cd507d155d2d3fcb9864b"
    sha256 cellar: :any_skip_relocation, sonoma:         "88e7f70b8d044a1a22c0c0a90a56f00cd3677fd9f2cb6ce855803fab9d84385d"
    sha256 cellar: :any_skip_relocation, ventura:        "f774042813ce8bc7ee5f10481e950c7e94495d0ed2087dfcdde44ac8ad16f464"
    sha256 cellar: :any_skip_relocation, monterey:       "f3c0fe3405a76a695c3fc9fc074fdcfd8d2010cba099ace37679de18ff935d0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac3a2967c8749a7fa7a3158342aef8fad965efdc6c23f884dd5289b96974ab92"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdflarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}flarectl u i", 1)
  end
end