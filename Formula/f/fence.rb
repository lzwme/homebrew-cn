class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.21.tar.gz"
  sha256 "23fee5313ed0328d1d70430c57f436896b812276b98caab215a4ab4e48059236"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bb25f3ee254a9d7cad1e3d746dba21d7474e3b1cd42bd818436b15eb3598c92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bb25f3ee254a9d7cad1e3d746dba21d7474e3b1cd42bd818436b15eb3598c92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bb25f3ee254a9d7cad1e3d746dba21d7474e3b1cd42bd818436b15eb3598c92"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa93a26d389e1ab017b31863557cc9953e82d5fb3e57e7c6db1214a56e805286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e42e17a1169e600daca1a58a701d91a350a37fff42c3cb2389ccecd13f9289e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "504f6c6a861c75b7f395fa46a17f64e04364616431c26645fc374c8303c26ecf"
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