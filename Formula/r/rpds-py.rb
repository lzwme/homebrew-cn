class RpdsPy < Formula
  include Language::Python::Virtualenv

  desc "Python bindings to Rust's persistent data structures"
  homepage "https://rpds.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/96/d2/7bed8453e53f6c9dea7ff4c19ee980fd87be607b2caf023d62c6579e6c30/rpds_py-0.25.0.tar.gz"
  sha256 "4d97661bf5848dd9e5eb7ded480deccf9d32ce2cd500b88a26acbf7bd2864985"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf2e7fe41dc568ae43cd22cd19a324807f8ce7918ce6ff0cfaa0654653a48ba6"
    sha256 cellar: :any,                 arm64_sonoma:  "250de2d26549d0f07bafe0b9c22efcae1aace5e655147576f12e20666b4f3d2d"
    sha256 cellar: :any,                 arm64_ventura: "2b856f712a46755ea73b20242da87bf0649bf6400888239d399c73ada69c8064"
    sha256 cellar: :any,                 sonoma:        "1ec7938b506d48b42b31a9344a8bca3fdcc2b6a98fef68462697c38b9f8f089d"
    sha256 cellar: :any,                 ventura:       "1fafa494d6590399b88428153993f3c6105387103be546ea90724e89fac53078"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad664c871c65d9d5782cc746f6b1b7ec0533b8ad2899dcee095e55766e0c105e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdab7eea61662af87f54d0e5cab7374bdffabf7b849c5dfb5c4e957aa4ec14d2"
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
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
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