class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://ghfast.top/https://github.com/charmbracelet/soft-serve/releases/download/v0.12.3/soft-serve-0.12.3.tar.gz"
  sha256 "87322bb76f691475f2ca1c5787481e738f0eff87f564417019e12333b71591b5"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f4f9266aa23b1fdf9cb12adc147ce74c7ada2578d7303ef5b1d54ccff2a92b51"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da16b731d451389d9ee179c86ee459ef89821fd344781534be776a1ebbbb88fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e8d53da103a8b8bcba0a646820956846120c3bc2bbbb6f2a70f3551ff6f0422"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b30fca717c4e56c414f19f82ce7065afc18952b15edde9b1ed321d991fdff196"
    sha256 cellar: :any,                 x86_64_linux:      "42d4a2c7c976ca4f3d44d1cbc39ce7ffbcba57cae0192c8d3e9546d032c79807"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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