class GiteaCli < Formula
  desc "Official command-line tool for Gitea"
  homepage "https://gitea.com/gitea/cli"
  url "https://gitea.com/gitea/cli/archive/v0.1.0.tar.gz"
  sha256 "b275325123c5cc68e45302cfd99d31259852ffdce21be711fe4872ac6bf8cc57"
  license "MIT"
  head "https://gitea.com/gitea/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fead28f4362ac22f7f9ddaed0de4edc7a1b7df63ec8569ca212f32578e9701e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fead28f4362ac22f7f9ddaed0de4edc7a1b7df63ec8569ca212f32578e9701e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fead28f4362ac22f7f9ddaed0de4edc7a1b7df63ec8569ca212f32578e9701e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d2dc78585b9fc84a63a63b795434fd1948a6f3cbb235d95f1e9c7ea97a7e4101"
    sha256 cellar: :any,                 x86_64_linux:      "3626037f94ce40cb6974279a1ee8deacb2da790cbff94b47ab4bf8ca779ecdff"
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