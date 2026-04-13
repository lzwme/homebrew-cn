class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.45.tar.gz"
  sha256 "a6ee909ff3bbde58c058d689a595e0d3e1963386d7577be3716a37ff73b03b09"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2aea56042c202beccb53a1242b51389f4cd98e3937ad2849a78aa192cb18c35f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aea56042c202beccb53a1242b51389f4cd98e3937ad2849a78aa192cb18c35f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aea56042c202beccb53a1242b51389f4cd98e3937ad2849a78aa192cb18c35f"
    sha256 cellar: :any_skip_relocation, sonoma:        "303dbb5545fe0caa8ba18f98836384c3b98a921d5476b588cb46b3780e1a9bfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b8b6ddbc5bb7e4c4b9eb73caa41d0d15e0fddc78a0390b3e5be95ae54667588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b58f3f86cbdd7a9434f4949c59d3f8b5a1efcdc41df88b8522e21afc02436b37"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bubblewrap" => :no_linkage
    depends_on "socat" => :no_linkage
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
      -X main.gitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fence"

    generate_completions_from_executable(bin/"fence", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fence --version")

    # General functionality cannot be tested in CI due to sandboxing,
    # but we can test that config import works.
    (testpath/".claude/settings.json").write <<~JSON
      {}
    JSON
    system bin/"fence", "import", "--claude", "-o", testpath/".fence.json"
    assert_path_exists testpath/".fence.json"
  end
end