class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://ghfast.top/https://github.com/charmbracelet/soft-serve/releases/download/v0.11.5/soft-serve-0.11.5.tar.gz"
  sha256 "499447cdbe0fdb0c7cdb5994c7b685f2366f472dc0f7f444640b23706c8ffd06"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cc0372b3347d305d93826b6ffdaadc3418753679a4e4f778e82915df08e9d77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbffab88cb9e08207cf0733acbb5e6960755d5eee0973d1dc2a0dbaf5a4e0739"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f67093b24e6ad6b163763a1f1ee12c5016655febb02c573ec325faf6aed54d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "934cbcab44cd45d83db9602d4fc131049f2d91a33ab9a36b732653efdc494ed0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efc58f332f618f6b4c160bcf0cca1b5316dc3fd86a0ede840160ef1528ff9978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b89027ba055e5bf46fcbbedf29bbb55a893eeb3693f55dce4279a06c3d7c8d7"
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