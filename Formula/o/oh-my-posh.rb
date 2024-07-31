class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.3.2.tar.gz"
  sha256 "1f0d92ab2f50d937aac7fdd06d7d2903260a1cd14b87f49533691922b84c349b"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60a66bbd0e587212619a7868275a48e0ad288956dc6870c2ba2fd38844e536c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "871052901c88e53106950e5942b7eb8657f6f82273f3f1a85aeccbd67a8b04d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01fda9af4fdbfc6cd62de7dcc734338cf20929e6bc71c0696a3236bf75b38f0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "577bf926c333f6d6a9663d9b898df8b18cd957341369546e9adf6ac1d34b17d1"
    sha256 cellar: :any_skip_relocation, ventura:        "dda8581127825788c0778de83be4ed18d94bd976788d1c8ce6464361fa543675"
    sha256 cellar: :any_skip_relocation, monterey:       "c307db02688a8133d4b2f4a722559e1699604f6d2d45aa4fa8b3554d3c50bb74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aad5602772ecd9410c09cd73f5fc27fedffa30f0e7a634e1b3617f5ace3bd25"
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