class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.1.1.tar.gz"
  sha256 "33442da7a12a7e2b4d11a5765cdf65af1d1b9d1c830a19972201078b2a3ace16"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f59dbea821d14c5809946f4b9a766358bf20e64aecbd3850ffde3a92c982fc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36c41eafe52a1e12e871a1b437c1ee87e55399181521e0fab678dc35401d1938"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43c412184e6f5880cbe61134a08bb9df6030fe8b7f313ae7b451af19390781a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "fed9818d4563bc1a6235e9df847d1e26d7125d7b284f7795864ad25ea76406dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfffff10b240f48c60ed8b4b561a1835c1e4bbd4cc08a3826f435bf04203e4a0"
    sha256 cellar: :any,                 x86_64_linux:  "dbede4bab5b9f013c22f895a15aa7313b7f8658b799c30f81959c8bfe8d78960"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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