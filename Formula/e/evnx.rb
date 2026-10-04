class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://ghfast.top/https://github.com/urwithajit9/evnx/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "e01e215612389d6640c28f5f1b86b2625269f2a7cf11349c5391e44d069eb4f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d17f21765b871ae8381756325e690523a4828c56a605a839533006e59e45e0d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cce2d17086c844852b3779e7edd28e1fdb0072d4dc90b18372dbcf1189926b86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4648e85c195c02576935c42f21919c9296ad4a2f95a7ce58b4bf0a55f7e00100"
    sha256 cellar: :any,                 arm64_linux:       "a98ac6b7116b0f9d9ad7bc82e19e42b1dfce3ec88394914ff926cae63bdb8a20"
    sha256 cellar: :any,                 x86_64_linux:      "6fc3f8bba6c6db824f6fc61e944510131d431fa1fb25aac674d173db52ef1970"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "All checks passed", shell_output("#{bin}/evnx validate")

    (testpath/".env.example").append_lines "API_KEY="
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end