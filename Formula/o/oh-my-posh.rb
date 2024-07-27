class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.0.2.tar.gz"
  sha256 "9dba7f9993e255904b42214473588ddb96bea6b8877cccf969399b9add2363b6"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6291db7559f8c0833b6f5f51d26e707bd5c27f83e4550e540fcff1ad77aac0c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ffb4c503cfdcb8eb58b469a02d3210e837b59171cac88d4ca7cfaa9c474618b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fabf461643fb4acebc43d3a51964df1d18936efb47d083830ca7c8d60eca315"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba57d28df5014859629024b6c88a795f7ab4f48ef2967b5c6bf367dcb81d86cc"
    sha256 cellar: :any_skip_relocation, ventura:        "7581c00339269d257f47e8507415ed6c4b432773e0854e2c77327bd5d0bac701"
    sha256 cellar: :any_skip_relocation, monterey:       "c61cae8a1e703e02b9221c60ab1b116d3df836953096b34054e3dcc074b725de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45ca00a921e1cff17b32d4d411fc0714ace3d57c837fbabd8994601d15fca982"
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