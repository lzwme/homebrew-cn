class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.2.2.tar.gz"
  sha256 "0e06b560332bfef4266696857c64cc948c0d8362cd524b58e099c0028ccfdcb1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e90fded06525eada2fd52849255c35bc3c8850995016d3653d10e2e0951e61de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfcd0b72538c09480314060277d0e4d788341e5d2f37b98ba29c2caec8ab957b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73ee7847492bdfcbd66e2413ff7d1b408f4590fc9a37f00ceb76595fb9817c16"
    sha256 cellar: :any_skip_relocation, sonoma:        "b858e41669e9bca00ebf88c86023eb4b0e07728aef21026410bbea8051c31743"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56a86d521b7ec52423a33f0aedbfd5a716a15f85d6d0e6c932b457fe045080e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a481245312abfbba719c16b7cb0db423fb198b87a8dc46288b4e18bef5f9704a"
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