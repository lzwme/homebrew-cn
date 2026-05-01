class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.54.tar.gz"
  sha256 "5bb6064189e154e3223c3afb28cc12d28aae88f7f6efbd4c1b87d2452df5c16c"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b12d36aa06f0f782331899a3be2ba419a251b4f97a3bf6b1cff75c740883b0fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b12d36aa06f0f782331899a3be2ba419a251b4f97a3bf6b1cff75c740883b0fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b12d36aa06f0f782331899a3be2ba419a251b4f97a3bf6b1cff75c740883b0fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "4794059fc2adfc8c827a4e747a50cbea0a5339550d43248cd8aa5facb23c34b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "984bc550aca1f77e3cdee575eeb9dbd55dfa3755e3f79d54116cda3a58bd6bf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16cf0cef8d9e4049a3f3218f986f3c5f19303f0151c990bde029cba2c8b0a985"
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