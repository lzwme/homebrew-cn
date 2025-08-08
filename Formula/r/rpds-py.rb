class RpdsPy < Formula
  include Language::Python::Virtualenv

  desc "Python bindings to Rust's persistent data structures"
  homepage "https://rpds.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/1e/d9/991a0dee12d9fc53ed027e26a26a64b151d77252ac477e22666b9688bc16/rpds_py-0.27.0.tar.gz"
  sha256 "8b23cf252f180cda89220b378d917180f29d313cd6a07b2431c0d3b776aae86f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "049d3abc6c28bf4c008c62923b98b71e2e4344cacb439ed8f2fa5126c2c4737c"
    sha256 cellar: :any,                 arm64_sonoma:  "9324d37373da675d9fa5632dfc96b2e08b28d285e25873bfe39a2e0ffb3cf453"
    sha256 cellar: :any,                 arm64_ventura: "dfd7841ace847bed364c6cc9ee963a2984f8fe79edeec962a0663dcb950d829e"
    sha256 cellar: :any,                 sonoma:        "1708470e7e750ffcf55b754b7bbd0725e0d22c26ce303b5d84242e35b8283ae2"
    sha256 cellar: :any,                 ventura:       "c6883c4f56f04cd88a602bb96eb27f02a113e565b4cf08b4580e768520a14738"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecf0fa7b27183247bfdca9b39f911755cc03772b09931fc60657c685fcc6a23d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "523db757ae6f23f796732c6575c4c57ba9016350f2f8180d205d975b55afc11a"
  end

  depends_on "maturin" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "rust" => :build

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/e0/92/bf8589b1a2b6107cf9ec8daa9954c0b7620643fe1f37d31d75e572d995f5/setuptools_rust-1.11.1.tar.gz"
    sha256 "7dabc4392252ced314b8050d63276e05fdc5d32398fc7d3cce1f6a6ac35b76c0"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    ENV.append_path "PATH", buildpath/"bin"
    pythons.each do |python3|
      ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)

      deps = %w[setuptools setuptools-rust semantic-version]
      deps.each do |r|
        resource(r).stage do
          system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      from rpds import HashTrieMap, HashTrieSet, List

      m = HashTrieMap({"foo": "bar", "baz": "quux"})
      assert m.insert("spam", 37) == HashTrieMap({"foo": "bar", "baz": "quux", "spam": 37})
      assert m.remove("foo") == HashTrieMap({"baz": "quux"})

      s = HashTrieSet({"foo", "bar", "baz", "quux"})
      assert s.insert("spam") == HashTrieSet({"foo", "bar", "baz", "quux", "spam"})
      assert s.remove("foo") == HashTrieSet({"bar", "baz", "quux"})

      L = List([1, 3, 5])
      assert L.push_front(-1) == List([-1, 1, 3, 5])
      assert L.rest == List([3, 5])
    EOS

    pythons.each do |python3|
      system python3, "test.py"
    end
  end
end