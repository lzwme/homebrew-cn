class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.50.tar.gz"
  sha256 "f2868556d501e3304e40e2d13dacfa9aa7ddbdfd3d2e8a1eff777ccd1e89812f"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4858ec73589db68ac337f68857b705eac14be0e2cc299cff8bd5c4f5db55c44f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4858ec73589db68ac337f68857b705eac14be0e2cc299cff8bd5c4f5db55c44f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4858ec73589db68ac337f68857b705eac14be0e2cc299cff8bd5c4f5db55c44f"
    sha256 cellar: :any_skip_relocation, sonoma:        "93347a352d852dc295eb50e30b0afe147d9bef74568406bfddca40cac52ae3e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d6a94bcde4549a5e5b1697cf660551a1b559960a6f7ae09bf48cdb78b471669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0c8188a5706918a3a435fac8dc1b3b21550b5a8bc2ff2a9b76d2d92b9958446"
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