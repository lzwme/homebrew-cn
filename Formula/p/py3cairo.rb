class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://ghproxy.com/https://github.com/pygobject/pycairo/releases/download/v1.25.1/pycairo-1.25.1.tar.gz"
  sha256 "7e2be4fbc3b4536f16db7a11982cbf713e75069a4d73d44fe5a49b68423f5c0c"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c6ff9ed94680a939d41992e2d24e63645f3a9c1ae8bb340e8ca4353d311bc8c8"
    sha256 cellar: :any,                 arm64_ventura:  "c5479effa25765aa0a6468759f35cc712e9ce6797e2c3ec9c351cf1249111ffc"
    sha256 cellar: :any,                 arm64_monterey: "9bba59cf4359ac97db7d3e8e72d3e3f79fda9e48c03d8d23b6c99ba6af70aa81"
    sha256 cellar: :any,                 sonoma:         "1b07710f64f72d9280c3e90b25c7da9da40524c84eef3c01f5dc18b5bd19300c"
    sha256 cellar: :any,                 ventura:        "ba1d32c8535fda6de719dacc0dd7a50504b3ea0911b3e7ff834e63d42f56a679"
    sha256 cellar: :any,                 monterey:       "168847c477b0fc0334326514d38c9cd2768a191479460a1edcdc287a5a06db81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d59987b0d76293a837cd0bb5b488f141a07208a847c4ade046cf6f2ac1f23281"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "cairo"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import cairo; print(cairo.version)"
    end
  end
end