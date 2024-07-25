class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv22.0.3.tar.gz"
  sha256 "929b315d12e11d5d95e2fadff8aa64dfb52628c307f03a755183e9f3f15d01a9"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc1a504309603b44bb775797178b3c775516928803119cf68f629a858f9c11d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dcf373b7e60eb17e3ac62d19cf887a7359580c9271987f6fa5c263e7de51d3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4e5a628d3f0528b845325b24c95b7e37e726e21ac298a89e41473115b4ca987"
    sha256 cellar: :any_skip_relocation, sonoma:         "c435563b894e4d9de7a551547ee81d4fa0f21ee57c5c8f70b3db3e006469f2ef"
    sha256 cellar: :any_skip_relocation, ventura:        "3807ade4bb6c96768dc846d41ebde76a92cff853c42fe931ad42aa310249d3f6"
    sha256 cellar: :any_skip_relocation, monterey:       "afa0113ec78174d055c3a25d11aad8d2af225e5237e2524b3c55941cacf6b0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c94281de891b7016f076d8f01bdd6293995d5cb9388b242cd7ba9ded2d6e7116"
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
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end