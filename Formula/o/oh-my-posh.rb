class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.28.0.tar.gz"
  sha256 "01f48323733beec688e26a1bc61022a773282f1457297406e89ddc91c5603f6f"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d114357b6d7872a4dbe882888fd6e2387ece75fb903dbe7793aa7b4808d2ee5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41b4f7f47902951e78bf2de758cca4a130b5baa966d1988e8171866a85b324b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74baf924f3047b536136f6e11f87617cd282ab70d781cb0d82699fc0c29734e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "48e257f3822ee08dba21181a0a84e35d8418f0657f67ae17331ebe80d797156d"
    sha256 cellar: :any_skip_relocation, ventura:        "7ed806f5aa4b2c98c647740ba4f70247d17d100d8104dd5dfbeedb67ad055d89"
    sha256 cellar: :any_skip_relocation, monterey:       "39788b91965da0e38c6e63fe249ba3f7f4b688509e9590329b63655ee5b2832c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a0f320e2b70d618b0ac23b87bb00af7c0ff2b5b6305e12eed154f1b20d014c8"
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