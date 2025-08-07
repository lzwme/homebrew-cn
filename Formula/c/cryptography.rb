class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/d6/0d/d13399c94234ee8f3df384819dc67e0c5ce215fb751d567a55a1f4b028c7/cryptography-45.0.6.tar.gz"
  sha256 "5c966c732cf6e4a276ce83b6e4c729edda2df6929083a952cc7da973c539c719"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6a1d9c83f8d751fc4b3c644de4338928aa84c4dbf5cdec7ef497b7372caf657f"
    sha256 cellar: :any,                 arm64_sonoma:  "7a5376e38aae02b66df571f9b15ca56286922bda25b5d108a22fa9f764abe226"
    sha256 cellar: :any,                 arm64_ventura: "9ea69c25ff1b6c819487b0f609ea07c108575ab00420377519574be7b3bac655"
    sha256 cellar: :any,                 sonoma:        "7cdccaa478c2c5072d211198e1bf5198425b0d3e601e3b1556022c054dd40573"
    sha256 cellar: :any,                 ventura:       "1593f7c96004f2828c128c4c962257c7a8d212ff162d938593f92cd95ef913d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9fce9c99407839794bc3041a65a217a47273c7d2bca1124fe76ed04572c5efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d705995b0cc6f6f9e5a4cfd3c72beeb1f5eefe70e27a4489e5078ca5c8b04ed"
  end

  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
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