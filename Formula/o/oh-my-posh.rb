class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.6.2.tar.gz"
  sha256 "8e804c20b6c0a22842704c7078174ca32a5741c8092276534e1ea529239a2e96"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "644fc1082fdf4ff041b6e05c2e608e4a0fef5803ac2522b4a333ebfcc9d566e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44627810a77341956cef0b48572e56c7aa9689c81d0d5a2cee8fe9f9c55de55c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31c4cf6eb650945183ff80dfe6afa0e5e5e0bc7796cc43099c344bbcccc186a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "27f5cea5f4d309336fe3718897734eae533c677a3b4d1a655b00748ca64e31a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2bff85951fac9e6900e42220aef04e568285a0c9c7794106661c0c42bc13d40"
    sha256 cellar: :any,                 x86_64_linux:  "eb49e761c0aad7da8947f41ad33e93ce792f2019c03868d2cef466b8e8cd3668"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end