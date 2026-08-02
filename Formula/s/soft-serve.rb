class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://ghfast.top/https://github.com/charmbracelet/soft-serve/releases/download/v0.12.0/soft-serve-0.12.0.tar.gz"
  sha256 "761baadd66320c3fe5a8f80473a860c24299819c2b438ae56a4a77a7643a6252"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7a48adb545607ee612df7b31c0c00a5d1a67e422af59c644e00932a8b64b8eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "872d07800230e401bd958ba419fcf8baa769d6794038be4cd6dca8b166ff193b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e770c770da5e2f4812ccd89e0a6c260f494ee6b5439d3e2a6fb0b67b71929a25"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6835df68edd4e41aa1146ebed435e775ea56bb055c10aa09ca09a9b47a61ee5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98eb273fe5f70fa1f1ac3c591d11a15c1069c7059f125086da4dc555cf27199b"
    sha256 cellar: :any,                 x86_64_linux:  "7d61c3825871d6cbccfb4d069476f789900f20eec7613b003b4b3a1f06b232a2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"soft"), "./cmd/soft"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/soft --version")

    pid = spawn bin/"soft", "serve"
    sleep 1
    Process.kill("TERM", pid)
    assert_path_exists testpath/"data/soft-serve.db"
    assert_path_exists testpath/"data/hooks/update.sample"
  end
end