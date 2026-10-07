class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://ghfast.top/https://github.com/php/pie/releases/download/1.5.1/pie.phar"
  sha256 "f82fb7a81aee71a44b5a0b0b7b35f0bf17502e7d19bff7e890b6f4a1964adb80"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a7c6e79b3bbcb86dcb6f9255d29d07dcd65b88fa282ab456a1f2e2bb7a2653c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a7c6e79b3bbcb86dcb6f9255d29d07dcd65b88fa282ab456a1f2e2bb7a2653c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a7c6e79b3bbcb86dcb6f9255d29d07dcd65b88fa282ab456a1f2e2bb7a2653c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "10f2932d34c8d56664a59252f36be54d1cc94e68921c48c8c9fd0ee129eab5f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "10f2932d34c8d56664a59252f36be54d1cc94e68921c48c8c9fd0ee129eab5f3"
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