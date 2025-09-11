class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.22.2.tar.gz"
  sha256 "1fc8aa15b3c09afde9aade860922a1f8ca76c499a61dab5f7a654cffaf10445e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "866f3565e92e0341547f745eb23186e12aaf3c8d27a79de46e9132d8672207bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b744fba6b7d2b99f0cc1fa87181671e8211b704095659220c1e5b8d2cc15090"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8456a5492458a4b573916e24c2b341dad55c41236d5977bb5ef9926dbf22df68"
    sha256 cellar: :any_skip_relocation, sonoma:        "72023d70ad789154488d03620dcc2b23818e1c1550faa42b6a313b43ddeb9132"
    sha256 cellar: :any_skip_relocation, ventura:       "8c81a2c46369900ab67c441bf268bb3a4e23cae286875addcfd31358b2bff9f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "065e55c18fb873647ad5997f705452bffd37e411c8cced499db53caf8c82a609"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end