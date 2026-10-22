class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://ghfast.top/https://github.com/getgauge/gauge/archive/refs/tags/v1.6.41.tar.gz"
  sha256 "74ffed36325b2b28b4d82dd799505cb0912efd9985812a2e50045dd4de117dd6"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eb67e759b49099f1b0d26171141b893b8feda774147628f705f80dfc809e9928"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "74c366ac9955fdd1f1ceb5f8900e60640acf6ddab4b5cbac4f1779563532d4a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea8a7954bf1dc90fab3a446f276d907b48a525ad3d06e94af899c93de66b6c87"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b809bee9e9c0655bad506fc4065ff8c8b927c70c8f89468b0dc753ebe3710e47"
    sha256 cellar: :any,                 x86_64_linux:      "4960498590cbd918f6eae09dfd9368528b20dd3fdaf5cbef272d98fefb930d4f"
  end

  depends_on "go" => :build

  # Test installs a gauge plugin
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix

    generate_completions_from_executable(bin/"gauge", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "Plugins": [
          "html-report"
        ]
      }
    JSON

    system(bin/"gauge", "install")
    assert_path_exists testpath/".gauge/plugins"

    system(bin/"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end