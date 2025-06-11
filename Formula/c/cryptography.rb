class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https:cryptography.ioenlatest"
  url "https:files.pythonhosted.orgpackagesfec8a2a376a8711c1e11708b9c9972e0c3223f5fc682552c82d8db844393d6cecryptography-45.0.4.tar.gz"
  sha256 "7405ade85c83c37682c8fe65554759800a4a8c54b2d96e0f8ad114d31b808d57"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https:github.compycacryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d252eac8aa4766582aa341d8e9fe416ce277eeca92ca17ffee8beb1a88d7e1f4"
    sha256 cellar: :any,                 arm64_sonoma:  "6377bc2fb51af02a902d6f13fe9ff56b14376d0593bb190843325797a706c3e8"
    sha256 cellar: :any,                 arm64_ventura: "f73b5f6752d8073a274048ead21348ad81651b69ee5b3928756e92d9a64fc29e"
    sha256 cellar: :any,                 sonoma:        "f6c852b05e9b921e23c4f5af2c8465df7f16300f26c8ce0f08a167179542e3f5"
    sha256 cellar: :any,                 ventura:       "ac7fc1bb12c8a459a7b5fde6f0ebc4708a99a4f43e77601b1a46ec82cc8909b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c6a7e787b236246d3fa19b0b9cd01de7b11d6fc99b001679ae39af83b0fb9e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "917dbef0491aa9727a25a4e0c526fe5f8417cae2bfb793d422559a1216847635"
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