class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv20.2.2.tar.gz"
  sha256 "d37ae7168f4a7b64d9088899c4e00f705508d6b2e9b942fd2b05e0097583c63f"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09f4d41216955d62deeb3c29b1b9ed23efdff53051afa2ed5b757c2c81e20f08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc6e10d2b7333bafb31c83144bb057c43cba59d734f7e1d59093827c112cc613"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "973adb933ec963cf5b0f33f0f6bca404be6dbf4c1db2fa75145c4b9ae94f7aa9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fc387035c29d66f282bfa657cb371875f03a7030d2102d56ee94d8a75a93f10"
    sha256 cellar: :any_skip_relocation, ventura:        "73bc9045dd6a1656f9d7ae4bd1b83861d5600096d3615ca2eae45f5b5c9892db"
    sha256 cellar: :any_skip_relocation, monterey:       "483df9490cbccdae5ce06f4bb2fb6da69e6cccc224e440bc15c8a5f69b4e4525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e32b60e11045b7b9f746bb6273cafe8a37c2b2fc00add07f4f8f99dc18382382"
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