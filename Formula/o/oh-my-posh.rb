class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.2.1.tar.gz"
  sha256 "39b6094cc125e33420cd2475bf282e422bf4614db28a0663fc37062facb3c0e1"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27cb38129c1bb00ac15ec0f9e039337b712d30cc4756b6e1f71a4b238849700c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c7ecef67979e3508bb60e5596d59dc47aaedfe3d95b0c7083ac6752fee2f544"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1eb2c864df84c64271592ebd2d30f0f2d334d40ac0ce5943f0f603542760b4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c35bd58bf252997c60c80564e77405c3bc8e9948bdff3c6d513619c01514ca5d"
    sha256 cellar: :any_skip_relocation, ventura:       "de86e869e821ae6076e07e9bb6364f30e5ab5e50401869e5f49150967dcd3cc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddfea76cb67bb45eaffc876d4e24ce4d7c7ddc5849a50e14f91241bfeca8280e"
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