class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.2.1.tar.gz"
  sha256 "8075d0d2c32f4be90704721f177f281656f6b2d5821b1e033af722e03f7fd3a7"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc0475eeb9b74eff27cfdae25c6485e96955af1f45d6cbe3312a4dd6473f7fb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf306f2d98dfaff51f662839ab391611a369fe4e57f61aee0a090c39810954b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af7be47f96d869d1f3bf75145a4bc0090ed6794508174191b21230f58940d46e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0de39b37e5bfee674a04e24c65c5929439e7a0ffdd8b07faa2bae2551185e727"
    sha256 cellar: :any_skip_relocation, ventura:        "c02f94d645821778358ba293f82ae002a9a511ca5358a472707c3dd7f8175359"
    sha256 cellar: :any_skip_relocation, monterey:       "e766bb34fc52400ce958cb92fa7b34a99037d454ba713a0b96614b899c5a8a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb6cb0eb3bdad810b57003d8a665223399bdf74f8470c6b2f1283f3bc2b7e976"
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