class RpdsPy < Formula
  include Language::Python::Virtualenv

  desc "Python bindings to Rust's persistent data structures"
  homepage "https://rpds.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/e9/dd/2c0cbe774744272b0ae725f44032c77bdcab6e8bcf544bffa3b6e70c8dba/rpds_py-0.27.1.tar.gz"
  sha256 "26a1c73171d10b7acccbded82bf6a586ab8203601e565badc74bbbf8bc5a10f8"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2a561a4404244bc17c8c10758d0464a35df5e29df259a7b6b4809eb9ffed0462"
    sha256 cellar: :any,                 arm64_sequoia: "3544fdb8e68f9fb28b3d0ddc0913e248c62d7d5cf93026c3857e080aee570e94"
    sha256 cellar: :any,                 arm64_sonoma:  "508188c7999b6355d36cdf71a104a90bf593f71e053c78923b1b834f2b457a08"
    sha256 cellar: :any,                 sonoma:        "dcb19b6c74267771944f9ec11b4cbc6c0050fa953792036c6fa8c7093eb635ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b9f4b93a024beea12d675f260be1112e38557d12c84d53f92e36beb149dc355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b9f1973483e96f4386941de39727f84566fb0f9f10741b6906526190d8dc2c"
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