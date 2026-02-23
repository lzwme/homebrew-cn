class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.30.tar.gz"
  sha256 "5c2db9f3e5043c6a5e44888c9c694749e7b8c502f0a6881a5a578abf96f91cd3"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb6829d9f5b562e41b7f6baf251841dbf3318f92261e66e0e0a93216cad096e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb6829d9f5b562e41b7f6baf251841dbf3318f92261e66e0e0a93216cad096e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb6829d9f5b562e41b7f6baf251841dbf3318f92261e66e0e0a93216cad096e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eb26ca7d27c32c282fbd8c37efe8960fce42109327fcb406047a5d035bbae9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df2a4bc38520914ae0203a9ce3234e3b49e53b6ac5797e4838ee01ba9077a583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c066a4a03d31cc0bf51aff7fe1a8c290e644a8d8ad61b0c11e816e4f03fb0c4e"
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