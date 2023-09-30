class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://ghproxy.com/https://github.com/pygobject/pycairo/releases/download/v1.25.0/pycairo-1.25.0.tar.gz"
  sha256 "37842b9bfa6339c45a5025f752e1d78d5840b1a0f82303bdd5610846ad8b5c4f"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1f4fa0367c3711e1fb468425cd54b32122448d0600cdf271755f33abcf6dab46"
    sha256 cellar: :any,                 arm64_ventura:  "054e3e8d6b51ddc73fedf4e8b1051e04851520f61b66413fe9ebbfe4a26f06a1"
    sha256 cellar: :any,                 arm64_monterey: "142fc41980869d7cec950bcc715f76a3535dc8dccb3724b51f37fecf4673087b"
    sha256 cellar: :any,                 sonoma:         "875627fc0921484ab770ee0e65a94271768d263244d7c57752dd611bc106ae9c"
    sha256 cellar: :any,                 ventura:        "05710eea6d1ab45a07e61839d9e037c9ea9b9cad3cf97421681d8e296835a119"
    sha256 cellar: :any,                 monterey:       "9f608a963317bcfa09151b53029db09bb918a799a444a95116bde53c59f3e345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "880faded3be9acd23c33639518cc697741b9dd6bcefd5139e4a789d8ef507402"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
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