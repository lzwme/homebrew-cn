class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.47.tar.gz"
  sha256 "c00fc762ddec7ab694ee9f036389e8e0a3f43b1692644a83c2b15cde83b88a75"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86775416e4c927042372f6c53de31dd7a56b950de533d7c707e0957d818632f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86775416e4c927042372f6c53de31dd7a56b950de533d7c707e0957d818632f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86775416e4c927042372f6c53de31dd7a56b950de533d7c707e0957d818632f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e354f02d0ac079e31af93836c4c6ad57407df1656524c3a924a7884b749ec31d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3adf520a3fe5b9e8a29ad42bb8fa4c318f6a35b3f1314483937a89349ad2aac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63e3d74497d2fd9714702026007c22b9e620e683b7a64d378a9e9391d368cf6e"
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