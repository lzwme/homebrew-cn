class PythonMagic < Formula
  desc "Python wrapper for libmagic"
  homepage "https://github.com/ahupp/python-magic"
  url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
  sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  license all_of: ["BSD-2-Clause", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06d8e0db50cb9189db22864778247489399a1c903028533d26975e6814c4f509"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49beebbd9b11698815d2851c52f9f723b43526b60e10f62af27c7cca93897327"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac2242f26217d22c85dc0bb774aaac28a45286f649e61844adcbde18643b714f"
    sha256 cellar: :any_skip_relocation, sonoma:         "69dd2c81748939fc09ed47ee0aa4a3131dc2aa5df6c9f0fb15e3fc3fe618390f"
    sha256 cellar: :any_skip_relocation, ventura:        "edb9c297cfce9f5572a70ed02692a75bd878ab5e21d1f26c09fbfb709695c523"
    sha256 cellar: :any_skip_relocation, monterey:       "b10ac2b777a65074ffd500bf39ae8bfb5ee47dad2d385cd8bfb7efac85410833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4af4f24a6d42bf6736b6deb84a16813b3a93b96f2005c864530449ee861c4ca3"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "libmagic"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .sort_by(&:version)
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "from magic import Magic"
    end
  end
end