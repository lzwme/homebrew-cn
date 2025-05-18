class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https:cryptography.ioenlatest"
  url "https:files.pythonhosted.orgpackagesa7fec5fc4dc19d4547261b35abfa0df9f75cae692c40ca2c896b9b0e50402b45cryptography-45.0.1.tar.gz"
  sha256 "8d190ac9b2fc80a6ddf210d906993978930a287c9098e35577a851cc2003bd07"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https:github.compycacryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6de721cfe57ea035d4b3998e16550151c26f7b874daf685f3941f4a92c2681cc"
    sha256 cellar: :any,                 arm64_sonoma:  "86d3d23795772492d75d38ea1e60a4a1523dc4583f09dbc1ccec007623a4eef7"
    sha256 cellar: :any,                 arm64_ventura: "836583d023685c6ed88dac6da134a48ad962ef68d5a703d1a8446e476cf67c35"
    sha256 cellar: :any,                 sonoma:        "0efd501d22b4f50775eb86f873ddab0c2d1c4d619a316c70b24667ed036b7af7"
    sha256 cellar: :any,                 ventura:       "19be45051c648757f90eeb371d408150802d8f7854604dbc82785315c9baeb7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb76bae184dfb84818dd068ed28665beff053e0ab2103de3b41d72bc1ddf812a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3352c3324095881e110a0697297b8f17fb4db62f06bd3f1d438a0108c97f933"
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
        .map { |f| f.opt_libexec"binpython" }
  end

  def install
    # TODO: Avoid building multiple times as binaries are already built in limited API mode
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath"test.py").write <<~PYTHON
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