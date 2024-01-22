class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.8.0.tar.gz"
  sha256 "334c81dd455e96882b09e44693aaf99a471519d4ed91f12fdae98e6ac921c02b"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16b2033a5f09dfe730296f66dbcdadfa6aa74638a7886722b1cda41a3196f192"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e174f7094582fbfa75bc2538eb33a422352010cf0d360821ecdfd3b8e99ac608"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10e977b4a2a815ee3fb419233e1af981a2a4b9397c2e1bda363288e9cf843304"
    sha256 cellar: :any_skip_relocation, sonoma:         "022bd0b05dfdc008cab79af7b60a01cee04844b4af7e299b774eed8386014445"
    sha256 cellar: :any_skip_relocation, ventura:        "54e9ca807c10f41f5cf4c3570d73585412ca6056797b89d915fc83b75bd1e300"
    sha256 cellar: :any_skip_relocation, monterey:       "48368630f6a5ce47b56f249faba33ab71e6498cdb4cb6eb5b54e4e48e5f43723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed20ee145a6237cbd0e338a9f7e094391b2d2c26f2f70b7434dcfccc758b8cd0"
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