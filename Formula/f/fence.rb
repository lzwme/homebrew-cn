class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.32.tar.gz"
  sha256 "6ba87ba1b2dfe12ac833016d8d6c988471629d4e892b96e0a2b818a5ab3767c7"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "063fe6b440c5d41134f712e16d22f9de9373abdce9b07110ca2c3279284f939b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "063fe6b440c5d41134f712e16d22f9de9373abdce9b07110ca2c3279284f939b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "063fe6b440c5d41134f712e16d22f9de9373abdce9b07110ca2c3279284f939b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f01b9050988922af969ca9986fe83b21815859ed75fdec53ce90eada0ecf0f87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d53471171cdab0784328a7dfc3606e9a6b7d5ff0ed36de70c915b87bb1f108d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "446bcf3507725651c930d414cf0e572fdfb3c19667a8b9b916ff4356097d7b85"
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