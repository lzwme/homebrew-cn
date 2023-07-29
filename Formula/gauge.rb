class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://ghproxy.com/https://github.com/getgauge/gauge/archive/v1.5.3.tar.gz"
  sha256 "828f769fe7916555af356122a4cd33f1ca1613a22f51d8ea9644fd9b240401f8"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26a971e7670f39ba487c642ff4f73ace52835d6284f7a63e695bf6792bbb1a5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f3ba0d0aed0138bb25ba4c5ece5d0a19046605915bc5504fed76b3ded87e522"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "400682b8d01358a1271ee4c2c2a91ecf96318db83b1033a3835001f24acea4ad"
    sha256 cellar: :any_skip_relocation, ventura:        "0e9c47afaf7c2bfbef3f9df01c693d37a2f2ba07a611dcdca8e7da93b302fddc"
    sha256 cellar: :any_skip_relocation, monterey:       "92f7c5b4b399e692117257bcd66aad16384a925868f5a776ef10715cef4993a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d0ef8b7a7c3dafd7600350a5cdfc8535209dde95ce46b1a4235516b8fbee059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aef47e78d3bcf9eb36afd6363d0a4efbb9243539e0594da9237cfcea124c631"
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