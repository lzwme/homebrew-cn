class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://ghfast.top/https://github.com/getgauge/gauge/archive/refs/tags/v1.6.39.tar.gz"
  sha256 "5062073294f7d0986380652c7935a6509fa7a7ae274ca51dd28b1587af844ded"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a712fff5a161c00d2a5d9bf0ace9453d99dd34913beb402d3c5c1506ada19a34"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ca457aa91b74a0f2b8df5517231f50e434808e4929980900cc25a402e5b8206"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb1190c94d716f73fbad8aaf018482d4ecd44e68c475cb51a10523573fb8a2d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "006e458e217fdb249d99c84e20cc049e4ac541b7a911b9a83022619868ac47e5"
    sha256 cellar: :any,                 x86_64_linux:      "eccac1327c4441806f3ab635bfb1643f23445072aac9fe9d84d46d7acff6fe2f"
  end

  depends_on "go" => :build

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