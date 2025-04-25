class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.18.0.tar.gz"
  sha256 "aff1d2e115ffcaf13ac7c5d48c610f22effe63e0b4002d34f52bfceb710fa9fd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27894d6b559e98a0d458c26cc5fd039ef6c816950a9ff17980beca761525882a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce66d312b335931d5be414200f8789380e9bbc763a290b59347975e393f67717"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd79a299b9e0448b45b0a151b51c4f65b93c5e506ac0724e48e34b796b618c41"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4b1602b11cdee924e9397610ff71517489168d9cd7933bbaa92a2a27443766f"
    sha256 cellar: :any_skip_relocation, ventura:       "804cfe336d8093d7c71be18e405a2efe3e241c1e07c35e025a79a802acd5bb3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe87311c6e8fc00b25f8901db8737efadd1361906f6ae614a4c22bc1dc21fac8"
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