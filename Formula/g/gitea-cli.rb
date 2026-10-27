class GiteaCli < Formula
  desc "Official command-line tool for Gitea"
  homepage "https://gitea.com/gitea/cli"
  url "https://gitea.com/gitea/cli/archive/v0.2.0.tar.gz"
  sha256 "a5a9f8b7efdfc1404d8ba4a8d0228a498f6883ee415e44df9990178d4b2c76c3"
  license "MIT"
  head "https://gitea.com/gitea/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3aeb3e12deb21ada4d48cf39179a77308ca44a009f4be1261cc48fa79895b46d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3aeb3e12deb21ada4d48cf39179a77308ca44a009f4be1261cc48fa79895b46d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3aeb3e12deb21ada4d48cf39179a77308ca44a009f4be1261cc48fa79895b46d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "44c34d0ed2117beb9768adf90d22674571717af685996e5dce761568082260b5"
    sha256 cellar: :any,                 x86_64_linux:      "78fce00489c7f0087031c3698a3a93e05876e32e2513ec30a7370c299940f55d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X gitea.dev/cli/internal/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gt"), "./cmd/gt"
    generate_completions_from_executable(bin/"gt", shell_parameter_format: :cobra)
    (man1/"gt.1").write Utils.safe_popen_read(bin/"gt", "man")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt --version")
    ENV["GITEA_CLI_CONFIG_DIR"] = testpath
    assert_match (testpath/"config.yml").to_s, shell_output("#{bin}/gt config path")
  end
end