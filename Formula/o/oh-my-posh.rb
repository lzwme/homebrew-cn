class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.9.1.tar.gz"
  sha256 "b96375a3a7ccdd8fce4a03e780a9aae38fcc262234a7056b3e8bbe6d402e4495"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "effb0dc0e659e048c37ce3d9b1bbb3296495cde0facf3bc71b503f514be7e8bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2732676315a85ffd964c98c60956a164f4042a744e1eaee8068931db9a3ad83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a01e4d7b048ba85033e0f1efde69d4e19e87317d42cf183520cd368e291ed253"
    sha256 cellar: :any_skip_relocation, sonoma:         "70785d872503bb55369f434970449189619961d872ca2597da367a309f07a902"
    sha256 cellar: :any_skip_relocation, ventura:        "7fc5dc748949e15fa211250381e4665ec801f9a092ea6303fc29d92e210cc9fc"
    sha256 cellar: :any_skip_relocation, monterey:       "9099596f336b232b32c8b6d1ed254207db4dc548038b113c8a0e9bb07055af52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "371d6acb2e2eb22670c81d89e184564c4c9159f2df5c822bf291232e1f9c5ee1"
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