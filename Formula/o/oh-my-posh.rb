class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.23.1.tar.gz"
  sha256 "830e347abfa8a84a979835f624da4eefd8279ce36b43b49ad20189aaa36bb9c9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42cee05537094f83517053ace36560f14848a05e351c43ba66335cf3b16d82da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d80573d6ccdae72b667deac6a081695f2ee05e16305d7797e1ed556db7d471bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f247a8923a9287b6eb9eb3adfc5f3fe5790c29fb5cd5c313983e5af038510433"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbe917b2cca1657bc19f27c6c4de247919c82c831748159d11faf48be244d7db"
    sha256 cellar: :any_skip_relocation, ventura:       "14f440f6abbe881cb5bca7584686e4e0d694a56c033e5be5db40807c95e93380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92a9c18f6b212e0ba43afbc0d35556e985165b72f1abe5022b2373304d7989d3"
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