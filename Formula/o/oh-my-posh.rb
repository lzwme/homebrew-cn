class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.26.0.tar.gz"
  sha256 "1950cc47ab6cf17d01ebad43c8b731b2b0f98333db6cf0683a11246734ae70ce"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e09327117f7de90199161fd61274a605ccb46d94a35a804067ea57fa1ec3592"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fec78f251374f5838ec95b13b0e354d3c714f80bef092fd308b7acfed36a08e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a07884cbbe0c948315d6889754d103763cc5291510950cacd7dd68503d7e6cb2"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb191f28647dc09e8cb1a35dfba553e62272723348770540c751ebe63ec06dbf"
    sha256 cellar: :any_skip_relocation, ventura:        "9ce23ba75717fe1f2858eb0dd0b38f124adbbdc0a484c4f1361a1bb138c1a180"
    sha256 cellar: :any_skip_relocation, monterey:       "0f8b99eb78455c20a2685d8cd6375c3b53701b13eabf2e7077953953f4605e75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c636bd6fec7b3fb5c4c38e25734c7e498ccdd775619a63b3acee9c0007fdb5c1"
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