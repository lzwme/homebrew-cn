class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.5.0.tar.gz"
  sha256 "6579392a043b75bdf93f33c07e48587ef8c724fb571481625fd3f609ff6a0d79"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eac4d6be2501bf89b30e5aee6c1d8503292d76ed9c3c705a8336b84a84cb6919"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd71b3582ac6830bffa3189f845e6756df146aec85ae3f6962fb4cc9a90adc88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3f8f18af33809602f189921e476097d8c72bafdad0e5d7d4b108eaea0c26dd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "4599393b63960aeba2b46c5951dfc32042572c4e833824bf54f7d0dc6a09a20c"
    sha256 cellar: :any_skip_relocation, ventura:        "e1c2a6233f61e317cc02b358e8f9da336cee40d38f3bd161cdb4573559c110e3"
    sha256 cellar: :any_skip_relocation, monterey:       "5a5dd471f505479197800ba4fca3d710e8ea24813918b6c37c08aff86892a6ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60fa7439596cca70e6fffd19bb894a8c0d77fcc196c0b79738cdbe126c846687"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end