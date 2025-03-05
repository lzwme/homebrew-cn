class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.1.1.tar.gz"
  sha256 "e8ef60bd2ba2d54b8168b0e85e4cc0dca20f226558ecccfe782f63c13d0c7ff2"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d48090f8e154bc5ba7725378883b77d258039605f1335f0d5971f31d6aab686a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f6d7b7ef3432e8b42ea696607c4ef25b9e29a0e6218d117df2502b58e92d49f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09a06d09f5f1aabd625cc1a506de3f7a13a085be32266b67c01b820c9c12a582"
    sha256 cellar: :any_skip_relocation, sonoma:        "9be88aabd7851dfa51e2f682e74acd49b68c765bb5bb9f5013311fc0dd063577"
    sha256 cellar: :any_skip_relocation, ventura:       "62bde056f3b843b8ccd8b999ce2e4edcb674d0be7d882ad6244cd517d409ebf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef874379a8b71c16664db6244193c81a6ea95a2c3706ad1f854782453da57043"
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
    assert_match "Oh My Posh", shell_output("#{bin}oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
  end
end