class PythonCryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/93/b7/b6b3420a2f027c1067f712eb3aea8653f8ca7490f183f9917879c447139b/cryptography-41.0.2.tar.gz"
  sha256 "7d230bf856164de164ecb615ccc14c7fc6de6906ddd5b491f3af90d3514c925c"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e10491715de269a316612143a447dde876bcc4def6b08859b0b83fbccf98bb7b"
    sha256 cellar: :any,                 arm64_monterey: "6074d551769b3301fba93d84e63fec3ae7f7f00e1c5457a1c9bffbe2163b9a08"
    sha256 cellar: :any,                 arm64_big_sur:  "9aa8c93a11dd3a166ef58ffb5cb6b9b408925cf34a55a7c2b073d1a78761ff20"
    sha256 cellar: :any,                 ventura:        "5eb1be30c37eb1c8b436163462bd3fd18cd9f27aad01b55f29fa784920a4b3d8"
    sha256 cellar: :any,                 monterey:       "28a8046fc4b304291431ec7fb715c89aaebeae7fe714a38c3dc4ed3d60f7fba4"
    sha256 cellar: :any,                 big_sur:        "8f91a408ea522b4af5260fb9227a849c9890497f608e4c4548c7b4f2a417490c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d0a609f56e54077bbb44dd5949fa6c959d177a1f967bc9cf4f508c1428e2357"
  end

  depends_on "pkg-config" => :build
  depends_on "python-typing-extensions" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "python@3.11"

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/0e/c9/6f9de9f7a8404416d5d22484ccdeb138f469cc1e11bbd62a2bd26d5c1385/setuptools-rust-1.6.0.tar.gz"
    sha256 "c86e734deac330597998bfbc08da45187e6b27837e23bd91eadb320732392262"
  end

  def python3
    "python3.11"
  end

  def install
    site_packages = buildpath/Language::Python.site_packages(python3)
    ENV.append_path "PYTHONPATH", site_packages

    resources.each do |r|
      r.stage do
        system python3, "-m", "pip", "install", "--prefix=#{buildpath}", "--no-deps", "--no-build-isolation", "."
      end
    end

    system python3, "-m", "pip", "install", "--prefix=#{prefix}", "--no-deps", "--no-build-isolation", "."
  end

  test do
    (testpath/"test.py").write <<~EOS
      from cryptography.fernet import Fernet
      key = Fernet.generate_key()
      f = Fernet(key)
      token = f.encrypt(b"homebrew")
      print(f.decrypt(token))
    EOS

    assert_match "b'homebrew'", shell_output("#{python3} test.py")
  end
end