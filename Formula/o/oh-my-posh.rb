class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.11.4.tar.gz"
  sha256 "c3f79e2886ec4a0b0f0224dcb249f999b97356a65cdbe187edd7a7d907c06776"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5126709a34bfe8a7fe733931ee3241f047050517b014a91676e01d0e543ec1cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69f6e5158e368f7d9acf31ba0a72bbad36415a0919ff53c6275ab92fddfc23f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e6f4c1474e68e59af91495c21d32074384cb3c39fe1a966a6feb24bed61deca"
    sha256 cellar: :any_skip_relocation, sonoma:        "52a6ee3e6f3c8d3d59e7697de55363cbb5a0bbdb29fbd097098b5966cff5988f"
    sha256 cellar: :any_skip_relocation, ventura:       "b8028894237db8f0174bdf8c62d39e8ef1c3b56c8297f9c41a2ed47d93f4f4dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21a45dc43cb651bc24490e81ec20b5d915382babb1d3a831aacbd0e95aacc1ce"
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

    generate_completions_from_executable(bin"oh-my-posh", "completion")
    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
  end
end