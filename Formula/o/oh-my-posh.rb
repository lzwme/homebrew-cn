class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.24.3.tar.gz"
  sha256 "4948798b82a3595a2be3259690ad6eac8ce055721ea6eaad28a57433a4987fd3"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aa337cade2ae87abd322e160e63b9d02f0baed14363d4ee7e298274797343ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5710ba710f4148d1dab1baf5fc867b85d32f81020d361e2c9664c7ef81252c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65ac264f1f86edd48939377b5cbbfba9e9e5d1131bccab6387bc5d95f5498f6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "051caee933bc7226c3fbc7e7fb18a4ac79a04760af02a7d3448f7ede2ca904a9"
    sha256 cellar: :any_skip_relocation, ventura:        "0ce005911a4e67d089568c086b8ce66bdfb8e64287b93205460735088c0da0e0"
    sha256 cellar: :any_skip_relocation, monterey:       "c069f2d69812e7129435e235a757074454dd546ef6dacae873541b0be7163aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8be0d1b49f7578983352cea81858056942eb2de46c04917db550dd014b68460"
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