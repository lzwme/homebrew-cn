class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.33.tar.gz"
  sha256 "4c7c01870da0ba3c04c2f90e71f254f40ae64e3426741b5ae8bab3863bc62def"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b23f75e8e24411afbff4217091f00076d0cb620938898c7749f9bfc50e6b535a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b23f75e8e24411afbff4217091f00076d0cb620938898c7749f9bfc50e6b535a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b23f75e8e24411afbff4217091f00076d0cb620938898c7749f9bfc50e6b535a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8b40fcaecef4f2e752e72fa23901038adf076a6dae0b482330be5ec876de1ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78cae0e0284d28c9230308b85b975bf1742a2157255de4df84cf13b7acb60759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec5e05c745aab1f671a040b1a08789e927a5c662931a0aaca2410d9d59ecc8f2"
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