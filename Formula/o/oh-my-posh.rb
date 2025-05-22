class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.23.2.tar.gz"
  sha256 "a71e4e88cffd162445bcd971e6bb26676cfe07a2d2d2ef60daeaecdadb6d4bf5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8322f98e74eba4a0982563e08db2ff9918cd90714daa20646be69e924f1c4d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e70ad93e32422802055f52bcc0bbfddc2725eb5ecf507ab465edc12ab8fbb1a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5cf20f588c6b48950166b1b2d65a11c0beec30a985feec9fa6f856a1b4a207a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c67ae6d5a9af9b06b95c1e7b5536ffeb7bc931818e0f396681ec440397d11466"
    sha256 cellar: :any_skip_relocation, ventura:       "e4c5db1c13e604503553604f8783b43b66d2bb153aa32b11debebe4cceeafb32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da4ee7cba8075c50bde45d04e2481eda8e4e8a91672496e553593376a0f3eaf0"
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