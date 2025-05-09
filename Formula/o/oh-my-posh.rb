class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.22.0.tar.gz"
  sha256 "9d17fcbe8cfdd923ab1ddd9901599b4880c5c86dd12e1882e95b8643d07d1a1d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dc03b4e14fbd0fdc3691044279686c7ebed993fd8863aa0e1e91820fec4f96c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9675a61e3d3ea872cc0921347da90165c081499a9fcb38313e1726f817efc28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8b79acb6d6e2ba0df5892ba1c317047cad7406e2d1ca91e406227e4c952e08a"
    sha256 cellar: :any_skip_relocation, sonoma:        "15cd2db111ca5745194d3b7a292c1d3efd0f9b8a9f28c7d24a5971eeff074c6e"
    sha256 cellar: :any_skip_relocation, ventura:       "b6af655b0b5ccad6444bcc0e6d26b8c1623e11bac466617054c5d32a897ac803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9cef3e8886bb16b713c44873a59857ce84dd6b9054692f598a53648fe95fe4b"
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