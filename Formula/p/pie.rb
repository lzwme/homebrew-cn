class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://ghfast.top/https://github.com/php/pie/releases/download/1.5.4/pie.phar"
  sha256 "3b7a7a1ab08705298b629e5eb4c13bb0d9abbb9ced6c86292a5549db71fc91ba"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5c7ab1d284fcb98e3734971cdaba1f727df2147f5efaad196bb04b0fab969c9b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5c7ab1d284fcb98e3734971cdaba1f727df2147f5efaad196bb04b0fab969c9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5c7ab1d284fcb98e3734971cdaba1f727df2147f5efaad196bb04b0fab969c9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ca2709f055be811ffb7011b867b96e5a42531df9c43d9cb503643ba5b7227872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ca2709f055be811ffb7011b867b96e5a42531df9c43d9cb503643ba5b7227872"
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