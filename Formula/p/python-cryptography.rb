class PythonCryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/16/a7/38fdcdd634515f589c8c723608c0f0b38d66c6c2320b3095967486f3045a/cryptography-41.0.5.tar.gz"
  sha256 "392cb88b597247177172e02da6b7a63deeff1937fa6fec3bbf902ebd75d97ec7"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8bd6fdbd9a6b621bb7d11e37deb3996d3a17312fbc8300531f1034c4e8e9226"
    sha256 cellar: :any,                 arm64_ventura:  "fbdb75e65c0b57c54dc2ce692fc0a410a615938040bd2ffed87f2ff0f851f967"
    sha256 cellar: :any,                 arm64_monterey: "7c931110a5a8b0bc7ed00ab1002229778244e7aea677c5376c1b55169d71e2f2"
    sha256 cellar: :any,                 sonoma:         "79b3932bf40cbbbeefac349f3d0205fe48e0dc1e8c9b78d7b348eaae2b664f16"
    sha256 cellar: :any,                 ventura:        "e3bf4e689f36ec006cc4422299af3b71de28c1685788f52a54a74186b5cdb98c"
    sha256 cellar: :any,                 monterey:       "9c123182839bb8f114c67c17df0c26c2a1119708048dbf8db21c51e3672ae966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41a59ca5d1daaf9a179b7b0207d46daab604fee39ba88d2209a19c05609be39d"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-typing-extensions" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/90/f1/70b31cacce03bf21fa645d359d6303fb5590c1a02c41c7e2df1c480826b4/setuptools-rust-1.7.0.tar.gz"
    sha256 "c7100999948235a38ae7e555fe199aa66c253dc384b125f5d85473bf81eae3a3"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)

      resources.each do |r|
        r.stage do
          system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      from cryptography.fernet import Fernet
      key = Fernet.generate_key()
      f = Fernet(key)
      token = f.encrypt(b"homebrew")
      print(f.decrypt(token))
    EOS

    pythons.each do |python3|
      assert_match "b'homebrew'", shell_output("#{python3} test.py")
    end
  end
end