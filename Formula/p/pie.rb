class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://ghfast.top/https://github.com/php/pie/releases/download/1.3.9/pie.phar"
  sha256 "b36a28d67e78a0ae3f9ae3329d0dacacd19f1b4bbaf31f057d45446329833e57"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74a3ca0b28cf951f4963c8aaf4a7cc7c84614313f5da62628c34e17c62d13bfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74a3ca0b28cf951f4963c8aaf4a7cc7c84614313f5da62628c34e17c62d13bfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74a3ca0b28cf951f4963c8aaf4a7cc7c84614313f5da62628c34e17c62d13bfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b74bc0022eb7b26a1c9227d098cc1dff2eb4dc70c7ee5f4965610e770854903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b74bc0022eb7b26a1c9227d098cc1dff2eb4dc70c7ee5f4965610e770854903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b74bc0022eb7b26a1c9227d098cc1dff2eb4dc70c7ee5f4965610e770854903"
  end

  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end