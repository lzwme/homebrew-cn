class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/4a/9b/e301418629f7bfdf72db9e80ad6ed9d1b83c487c471803eaa6464c511a01/cryptography-46.0.2.tar.gz"
  sha256 "21b6fc8c71a3f9a604f028a329e5560009cc4a3a828bfea5fcba8eb7647d88fe"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  revision 1
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5ae544d086854e5470430dc679a5a67af0de7ca9488505de52257758ea397b2"
    sha256 cellar: :any,                 arm64_sequoia: "138b13af0196b5ae565d1feeaaeb9ae5960395dd489f65da1c923e05c616af88"
    sha256 cellar: :any,                 arm64_sonoma:  "6c8df25670b68b377c6f616edd0e5edf91ec4c1fdbe71236869bdf952f519caf"
    sha256 cellar: :any,                 sonoma:        "4ce69b857ff3d77ab409dc23dbf5a2fca3f21898151975d461931e0074a90563"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ab5212fb26d5827e2578a1943327f6271bf0f11b2151fdbd79f42e94eaa5de3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f505c906c983847ea0b0bad1b44a2f386441f597ab788e6a193377051f18319"
  end

  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    # TODO: Avoid building multiple times as binaries are already built in limited API mode
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from cryptography.fernet import Fernet
      key = Fernet.generate_key()
      f = Fernet(key)
      token = f.encrypt(b"homebrew")
      print(f.decrypt(token))
    PYTHON

    pythons.each do |python3|
      assert_match "b'homebrew'", shell_output("#{python3} test.py")
    end
  end
end