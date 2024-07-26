class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv22.2.0.tar.gz"
  sha256 "0ed8f310350ccee13ed26f1fa1b394bbaa7504f4be94e20298afcd12cde2154f"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b23b2f090eb1f453657e1e913e9bde99a8872c325db643c1afae485495fd3f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da48b47fb03b45abfe5df5f0dc406537ac4e36e494a41a90a0685ed1053e075c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b286477941116b66ace95b69b3417fd0af2c2500ef0e93e8a7f1ead6ca66a48"
    sha256 cellar: :any_skip_relocation, sonoma:         "8dd8039a2941becd791db5be15e4f751442105dfc3e1ca39a642121c52de6b37"
    sha256 cellar: :any_skip_relocation, ventura:        "34f0f8912ace3d2f5c5d42565de05bc124c0e99c634b0cf7b3d845bf73906355"
    sha256 cellar: :any_skip_relocation, monterey:       "f472f481f5e510682283374ddfcbc916694f4447227c2d8e026d66d2cd22e261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87f0665c62fe10c9b442d41e59452778d70aa43dbbe14c0b9f6209e12d86b650"
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