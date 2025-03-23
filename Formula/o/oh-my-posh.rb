class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.5.1.tar.gz"
  sha256 "b03b301b8b17b1eca86e89162ae8cf97d98c8a4b093df9bfae44416847a04542"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3632b8537dccd9846a7911be5aeeaa31d3840add955a48a3fe711fe13fc60814"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e893cfa49f4886027e896e294d58717bc01ab256d63ed059cd4747fa028fb71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08b3606ee0f6392142c8c2407f5856d9157f60f96f692af2b8ba5df04cf3c2bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b492fc5d289f034c6cd9f79b26b5d6b02f3922c3b82adeb21863f939eaa2467"
    sha256 cellar: :any_skip_relocation, ventura:       "d614a2af4402080a8368187d517e29746df6fd4727b68736a33fc134143410b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbd08bcb6afa240be0971aff5c695b1d3259643b0e6078269024ee4ed6325e0a"
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