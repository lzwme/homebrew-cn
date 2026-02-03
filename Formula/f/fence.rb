class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.17.tar.gz"
  sha256 "933697dfaf8d8a0f34b09f440d3fa4329ea6cbd3b956e317a0117ea391c0209d"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "170c87b7e6e3df62a647ce3de2e7e9136a6e02323f2821d170eb4303d278de08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "170c87b7e6e3df62a647ce3de2e7e9136a6e02323f2821d170eb4303d278de08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "170c87b7e6e3df62a647ce3de2e7e9136a6e02323f2821d170eb4303d278de08"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f9c819fff3ad42903ac22c1006ada6339b850ae30698cdf43ed813f510fe053"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "397b93d7b5912af02443d0d629251f2fccf9a639035e7c514f1f36dcdbb5927c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e73ad4b0aa692b17e80dd406a7453668d029dacb507beabc97e109e7b8b0e35"
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