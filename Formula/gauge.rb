class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://ghproxy.com/https://github.com/getgauge/gauge/archive/v1.5.2.tar.gz"
  sha256 "eda52736debd20f565f8c453269bdebb15e48d3cdbbb7f222249491ddf159671"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e8a8e583cb38e55a471a6a9911f9320ae8d1150e392eeb2bea1e83630681891"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4393dedffac7ca4c4d48b3bca60ddb47d4f41f55049f64b7478339ce3b7a9564"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e511a5293b663d3f5c7dc8082ef73dd7fb4c95f2a82d49239d2534fd52d50895"
    sha256 cellar: :any_skip_relocation, ventura:        "86208b96d3d7e74963e56c341edf67a372aa9cccd7eebd9848a609f46d1d71d3"
    sha256 cellar: :any_skip_relocation, monterey:       "3bb35dd119f65fe4cc6824841f1e435db03d71a6c179c3ee47cade2bd4e3e42e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d57897f3bb7b1d407f8502c3b672c1aec409c042a99f0e52aaa88e7aa205d89f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b844d9f83df7fdaa55443574fb0b19e3fa1dea5d117d09b44c3e8002431a28a6"
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