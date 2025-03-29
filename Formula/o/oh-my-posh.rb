class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.6.1.tar.gz"
  sha256 "a6e41f48abd3982ba1cd20e1aef7b8ce8966bfb25cd95f0410409fa5909ab90e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d2f8c8aa2f3a726f7932780d4c438ce6fdf06c96f1cc423b7c86ca9e8f71184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "493cbb8d836c2945be3c7b148805242775db3a1e4ba888e3bdfe79da91b1c94c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "931ca612fc8573d256d5bc645c37395c656b18f385eb6efb007ddcfddc388f37"
    sha256 cellar: :any_skip_relocation, sonoma:        "c54bc8e4ff719301923c0bbe8da25b826e78ef39fcb5511933477b41c800ba6b"
    sha256 cellar: :any_skip_relocation, ventura:       "ececb3b32d04f224d196aeb2f3fc580091d21712b849d78eb4b4b9794f8e7ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63909ad389b59a589e2c7fd352b74fe18b3971fe10b8df7d591be50de677e071"
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