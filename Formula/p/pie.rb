class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://ghfast.top/https://github.com/php/pie/releases/download/1.3.7/pie.phar"
  sha256 "1c70946eb99d5ac163b38bc85bd4945675893f284a132ce52049e3b1fb092532"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdb90a5e411a776aba2b36ac9c4ab414128e5e9b4959547021a33ae1738b65aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdb90a5e411a776aba2b36ac9c4ab414128e5e9b4959547021a33ae1738b65aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdb90a5e411a776aba2b36ac9c4ab414128e5e9b4959547021a33ae1738b65aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "8755f4f7a6aecfb61f272ba74baa81ec11162c166d77458c71a201e4412d8fca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8755f4f7a6aecfb61f272ba74baa81ec11162c166d77458c71a201e4412d8fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8755f4f7a6aecfb61f272ba74baa81ec11162c166d77458c71a201e4412d8fca"
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