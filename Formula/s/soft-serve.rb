class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://ghfast.top/https://github.com/charmbracelet/soft-serve/releases/download/v0.11.4/soft-serve-0.11.4.tar.gz"
  sha256 "4ea841042b6eacc84eb9310f76f02d5e64e3de045ba503f53412fbde6cc3e5e7"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e0886c7af52e090f75d28815ac19bf800fb18179bf05799f33761fd90073bbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d18e33bbc43d1771b5837f4f195a5d992f608d12bd14cf0152d34f506c7b5331"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a20a39630055285948972df3e045a8e83c90aa4d3b309b26b7eff6ac557c7a22"
    sha256 cellar: :any_skip_relocation, sonoma:        "493c007e5b74449b9c694d8f63c4bf7e92ef0b33ff7cb5078457e6eeed03744c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe4823a05c8bdd78c7d1fef7e2cb999c92558fe99e3f6491bc308fe981aa2cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01fe307cf86803f152fdda01d412918e223ed409e7eadb52eeeeadd9dd6f96a6"
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