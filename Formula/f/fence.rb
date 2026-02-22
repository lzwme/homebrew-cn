class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.29.tar.gz"
  sha256 "e4dcb3d0afd1d0bd54557baa9e80c0bb002c16b3a7b54dcdde3efdb46cbb0f77"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f6c445635dee000a67ead43e84e7ecf13cc598180da4665071e35f4f54360cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f6c445635dee000a67ead43e84e7ecf13cc598180da4665071e35f4f54360cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f6c445635dee000a67ead43e84e7ecf13cc598180da4665071e35f4f54360cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf022eff477467aaf986e31e5153cc6ea530c5b3e5abcc4f1df01b35d645de9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ee2b0a13b5291318ca5610fe04cf5c6d9ac1630d2a2cfd46f715c30a7e9eb4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de8ccd952acb945f6c0926e224deac82f998f245e094b100ce28bf9155888872"
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