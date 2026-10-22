class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://ghfast.top/https://github.com/php/pie/releases/download/1.5.3/pie.phar"
  sha256 "34a1315073b6089d4cdf4cc5a8295ecc6d36cfde683ef785582f7da0d74f127b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "448c18c675720b59d8390a6bd5d350e4420ed5526e37c661bc867fe0e952beaa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "448c18c675720b59d8390a6bd5d350e4420ed5526e37c661bc867fe0e952beaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "448c18c675720b59d8390a6bd5d350e4420ed5526e37c661bc867fe0e952beaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f4789825f61043ef4c78b7edb704ed7b094de0172f87d6c6988bdaac09994729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f4789825f61043ef4c78b7edb704ed7b094de0172f87d6c6988bdaac09994729"
  end

  depends_on "pkgconf" => :test
  depends_on "re2c" => :test
  depends_on "php"

  allow_network_access! :test

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end