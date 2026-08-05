class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://ghfast.top/https://github.com/charmbracelet/soft-serve/releases/download/v0.12.1/soft-serve-0.12.1.tar.gz"
  sha256 "e5b2bfc6e57856cf93bbef8973ff366609b3f9a82a346238ab372fcde760050b"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "838b42b01cec716d45afc063a09e69d69a8c2c82f6217e03a60afefcca890374"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83f3c544f0efb5ed8d42cca027cefc37592ac8677f4e6437cd256bff9ce40e71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf37f091b8da889faecb55d820cf8f23dde3c76a8ec9a2d10de2c9d7b2ed6efc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9beee9892cd63ef151d476945c438615831f19dbc551480c4b18e94e8d37fa25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "160c200bdc90f14d457194366abd53bb290cf0aa695e0cb18dc7389a9e70e836"
    sha256 cellar: :any,                 x86_64_linux:  "109d900c148d3436792d4d24b42637a46530258a10506a8b263700e9a82002dc"
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