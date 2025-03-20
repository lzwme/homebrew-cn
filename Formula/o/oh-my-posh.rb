class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.5.0.tar.gz"
  sha256 "bbc0029ed0f5871968add92522a2ce542cc94e22995921f03b2e1acd8f35109c"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8ad099ce85e7ba93d11738df4779937391944eae6deed874882f0f2ee65d029"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "394ac8b506c07e7fee5b6c9cb2cba92e99528986860fea82f1a88b33ade4ff3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7cf3a92be3c0a4c32f88f7abc96ea89c09266888ef9db01d1514749f5197071"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d276bf3b1766e03be0a7af90047e0b28ac8066a34d8e651d3b3519c0e49e3c8"
    sha256 cellar: :any_skip_relocation, ventura:       "cfbdc2a3f0c7777879722f2dcf720554234c8108e17f306b0c121c4f1867c35e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e25137caeccbd5749b79ca5b8598f29f897f49bf094b661406880976f9a1a90f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
  end
end