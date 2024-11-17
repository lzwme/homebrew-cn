class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.6.3.tar.gz"
  sha256 "75b7e14bac84bcfa6f59f8f1343e68e1e95bf5ec58015632aee7ad0a20314abc"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77aed4ca57be04d18eee85114cfe907dde98a49b6b3fddd5ced3b4dd8a097749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5d34070eb002ffc27e2879aeeef1018fb2aa0b85a7f92df23997244c7214062"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a77b98ebac09015f738a8d061aa69797da9c3dab21f9af011ff5220d78a4250d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7fcc967da2b4d4f8bf711c7716d4d7e2d33d70b07de574c5088f1aa4bebc335"
    sha256 cellar: :any_skip_relocation, ventura:       "584e7fb2e90e4eef5a09aad76676ce536dab6fb38d35b3b95716968cf4ddd742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e17fb5ba07038d93bb52d53a92d9af14a0c21cc557008a5301a13da3f03f1571"
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