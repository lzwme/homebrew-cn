class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://ghproxy.com/https://github.com/getgauge/gauge/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "2273df0d3093bffaf90937dac60e2ebed5ca79009c8ce2ea6b6bf28861e7ddf3"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff5d5f1d6eb29587eb417d5b1641491b084ec89fb0f9d0b6f374b4e422a56925"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e210cb32ee830a49e2df310548636d671837673313e1c7166826782c2b8366f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cebff5daf347bbf8ddb9031b0095c92ab23a7f82ee23927f1fda8ba765961c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "0adcfc20ae2a0be1e88695f3d58083cce726bc4d2b70f8589c288ce8bc4489d3"
    sha256 cellar: :any_skip_relocation, ventura:        "69ebdbf04a3d3c5a0b74acd37743fbbe4345ef61fd3e22d8ea20931ce4803137"
    sha256 cellar: :any_skip_relocation, monterey:       "0c3b9c5fa35adb8ddcd2abcc3bcd8f7ba4dc323298ded1a32be4b281915d10b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c533c794b2926a7a47357f4da4fea940d060fb665f5f71c5928baaffd828b3f"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}/gauge", "install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end