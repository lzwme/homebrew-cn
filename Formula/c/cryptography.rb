class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https:cryptography.ioenlatest"
  url "https:files.pythonhosted.orgpackagesf64792a8914716f2405f33f1814b97353e3cfa223cd94a77104075d42de3099ecryptography-45.0.2.tar.gz"
  sha256 "d784d57b958ffd07e9e226d17272f9af0c41572557604ca7554214def32c26bf"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https:github.compycacryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "34f2674547d263a9832edf392126456bb567d201aecd2a028c15b844a75cca0d"
    sha256 cellar: :any,                 arm64_sonoma:  "c4f2106c32efb0cf02795523ee4cb49c911ff5a403cc22c58c2f9881896f0ead"
    sha256 cellar: :any,                 arm64_ventura: "7c3741881b4f4e16316cd0f39ddfd9ddddc8c4a867f63ad8d5af82813b6e0f40"
    sha256 cellar: :any,                 sonoma:        "1d466163f8b9d94dc3588c91ceb544ac0ae7dce822c3b1bf47f962572f99ef0c"
    sha256 cellar: :any,                 ventura:       "2d068c184966383314a2e9f73bfb6f9094b0a6995f69283d9c2ed095666ff762"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c69b4b5f5d70869746da025e55b8785371c20dd3d787026eb26de19d620a43d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ac6bbf5b90cdcc5a76eadc0f81f96cbf63d1695a9a0d6d68aa236f7a0522e82"
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