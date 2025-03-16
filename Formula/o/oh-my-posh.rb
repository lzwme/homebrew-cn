class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.4.3.tar.gz"
  sha256 "7162ee65901a7f59341bb181b06fa6d0ce15d7d784e016cdc17be4e00a412429"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42ab9453fc99d8c57e8b58909c4067f2f3ee3b2620483476a8ff6807ce494fc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "119cceb5cd484b70b8e02cf2c31f8f7f73777dab5706823932d48349ea8d97fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47ac82f7af338b241cc063d6260fc2534f0b0f309519145e2a1e748c97a9812d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e979c0c393b884b4e456f4cfba031e81ac0232a9728daf665f87732b3ad77c3"
    sha256 cellar: :any_skip_relocation, ventura:       "2e3b49d9e9953b14641c4e1ac5d54a257f5488be622e23d5ec10ab9bcbac0d7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f8e0bc7a187c72e977bbd09f0f8a5bbdd85ca6e529f8183b3ad8dd066845e99"
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