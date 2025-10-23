class RpdsPy < Formula
  include Language::Python::Virtualenv

  desc "Python bindings to Rust's persistent data structures"
  homepage "https://rpds.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/48/dc/95f074d43452b3ef5d06276696ece4b3b5d696e7c9ad7173c54b1390cd70/rpds_py-0.28.0.tar.gz"
  sha256 "abd4df20485a0983e2ca334a216249b6186d6e3c1627e106651943dbdb791aea"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ab4d5cce2974a42c5c8b30ef551a329b2f3da83193a1acf78e1f7a1888509fb"
    sha256 cellar: :any,                 arm64_sequoia: "217e63e10f4e098b4879dd16653fb182b34e1e7968f0fd2d245f2c088eae2798"
    sha256 cellar: :any,                 arm64_sonoma:  "4e6026531d9aa4d1e168bbf7c2f4be2f201282bc013922fbba6c467373ca5494"
    sha256 cellar: :any,                 sonoma:        "ce8ec3940c3ae977a2f81c79b0341366aa03ea02be270c6b2b6c96b016cbb139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cca18b616a53b259104db0d5e06f07a1a27703d586767ed7a10bd23c6a7e34d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbcf1d6e432b3a771a1309a49550fe12230d2ae15821ddc5dbc27c4e765e5a89"
  end

  depends_on "maturin" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
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