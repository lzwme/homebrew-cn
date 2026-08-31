class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v31.1.0.tar.gz"
  sha256 "2cebea8497e2b0b9805e25a960d65020de0111cb7a3bed1f607183fde340e583"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f81c3d94b81ad1096ac30f732dcf2102b20fc4dd717aa4df61761231ef3d4edc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f47ff299cb0473458f961b9be179a2dceca004217af523cd182a476b44c1462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35c2da6d8153aa5dcdbb7d70a199a74e71322097577a1d3dbc0cea6d4a3a0603"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd71a127c1e6afbccb36efca7c7f16a63e97449cc45e6fa03a81c0de37f7fdda"
    sha256 cellar: :any,                 x86_64_linux:  "e6251d76071b34d85ee84f41015b86856a05cd3ba46471afc53f74a12766b6d3"
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