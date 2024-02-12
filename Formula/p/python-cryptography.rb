class PythonCryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https:cryptography.ioenlatest"
  url "https:files.pythonhosted.orgpackages0f6f40f1b5c6bafc809dd21a9e577458ecc1d8062a7e10148d140f402b535eaacryptography-42.0.2.tar.gz"
  sha256 "e0ec52ba3c7f1b7d813cd52649a5b3ef1fc0d433219dc8c93827c57eab6cf888"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https:github.compycacryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e7dd37573f85af118747591b4cb842b155ccbe3e66f7d6c52f6ed024d05a954b"
    sha256 cellar: :any,                 arm64_ventura:  "e1c8b5ef7a22662b7fb283977ff04a36f3f9722122e0421cb83c74a198323fad"
    sha256 cellar: :any,                 arm64_monterey: "8721cd8f6f6cb3b0903f66be7ec3b83c420b3285ff67a66c5583bb4034b5f927"
    sha256 cellar: :any,                 sonoma:         "1746d0508011031efa1961b23dddf54822ca00f2cac265b35f94e86cb8ee6de6"
    sha256 cellar: :any,                 ventura:        "8360c4ca7b89408c572cad48b598a40a02e60fab6b94a4f3add1d07ecca08019"
    sha256 cellar: :any,                 monterey:       "aadfcc9c97a2cd7e4d99f32792af075e43ade84a98b7ef1b55efcb9a09f17979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57530e86e61dc1fe280f4e9eec0702a3b49e98ac0b1fda78a03c6de9f34c71f4"
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
    url "https:files.pythonhosted.orgpackages7d31f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesfcc9b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
  end

  resource "setuptools-rust" do
    url "https:files.pythonhosted.orgpackagesf240f1e9fedb88462248e94ea4383cda0065111582a4d5a32ca84acf60ab1107setuptools-rust-1.8.1.tar.gz"
    sha256 "94b1dd5d5308b3138d5b933c3a2b55e6d6927d1a22632e509fcea9ddd0f7e486"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec"binpython" }
  end

  def install
    pythons.each do |python3|
      ENV.append_path "PYTHONPATH", buildpathLanguage::Python.site_packages(python3)

      resources.each do |r|
        r.stage do
          system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath"test.py").write <<~EOS
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