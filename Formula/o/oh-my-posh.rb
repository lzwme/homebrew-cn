class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v31.1.2.tar.gz"
  sha256 "fe81ce9f0d496e7b474dbf03c772a0970e78675f7cc94387fc89908be13f54a9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a738d8efbb975bdc7d739a4cafd141e89e027aa7ba2506e9cb4c8f1b3c2bc31e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "334bbde677e6a53dfe0e36580ddd19407a5a966143e8352dd005f024f12024ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ec5c27f3c35079402d437b69593082aba4665d997a3d2ca970b2b4dae99c562"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5e34ef9f652007b3c698bd431869da2c357627f6680c300174672347407f101"
    sha256 cellar: :any,                 x86_64_linux:  "0b5e81b995967c2724481fbe2006d249b8550e04425b49f3513a430c58fd3cb0"
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