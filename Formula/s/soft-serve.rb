class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://ghfast.top/https://github.com/charmbracelet/soft-serve/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "473359acba9a4da8b3d01485bf1d17a9ae885c3e77450ca551e2987b0b1fa9cc"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3bb4c2b97911fe1ac1a2bbf03369e7e68916591989c004480b16f1e2faf54ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "095ccca938f044b0004227a2a5e8c241fc379565bb4d3cfdaefdb59c8a823876"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bddb48cf0ea6cee294a0e8e0a074c7808bc50e15fcf9d420f6fd4bc77c402ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "90deded4919cfc446d97317ea58a09804481158344986ac10fbe1cf04dd62fee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e4a23e65e5ad80b4e552c780449f52d4bc604421b28bd20327e139b9dbb6e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c18256e98a6cc59430f49335f676918d4c5b5c0068999dcf71efd9dcf11027c0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
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