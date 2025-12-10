class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://ghfast.top/https://github.com/getgauge/gauge/archive/refs/tags/v1.6.22.tar.gz"
  sha256 "4600c344ae29b290d9bd3cccd9ee5611352be1bbda1e1a0e687ac58c0dc546c5"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af8c0fa6ad1d30d4cff7789bdc1149a984921056c3b7f8f036cd094b36d2c152"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "021f752b4bb0e84eed050ca0b19c5d37bfbfa065f89e81a468bc1d000eb337e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb774a1dd3de3a08391dfc46355da544d1a0044a6193f8a4a489d796ec30e81c"
    sha256 cellar: :any_skip_relocation, sonoma:        "da550d7e8dae631609684013f859bd27d72d72cbe9eefbd7a7adee3405e0b00a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "583a138f1ffb28dc9dee08b37025632159b13ecd65d9d52c7cf4e0d5bac1bcd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a88d4a6bd5325e6670252f492caf8eee72c5eefb2e068c43a6a8faeb827abc2"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
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