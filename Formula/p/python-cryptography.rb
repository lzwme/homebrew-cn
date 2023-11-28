class PythonCryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/4d/b4/828991d82d3f1b6f21a0f8cfa54337ed33fdb52135f694130060839cfc33/cryptography-41.0.6.tar.gz"
  sha256 "422e3e31d63743855e43e5a6fcc8b4acab860f560f9321b0ee6269cc7ed70cc3"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "23206ba48a22fa3ee74c5e5802e61f73893f1ee4b382d1a003a24e2fc8268c6d"
    sha256 cellar: :any,                 arm64_ventura:  "04c9d17ea5f926c8d8229b7bc5d29847e37a6ea7959d6727931c753f57f89c3f"
    sha256 cellar: :any,                 arm64_monterey: "37b2fa89f0b0871b095cbb1c8868929a8ae10752e61c510d724d7fc598bd7c44"
    sha256 cellar: :any,                 sonoma:         "aa6fa187ab7932c098573bfaf2ea541638b2bc4301d2d4862dae58a180e21b2e"
    sha256 cellar: :any,                 ventura:        "26f4defe299dbab13d3c67a06487e68cd14c960e2aba7244636d5814607bd565"
    sha256 cellar: :any,                 monterey:       "a6b73f375c9e7d11e8b1c54a08ec96b58c3deff7a7c3238ff415166418e6c4da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c31da51e3ff9f0a76a82701aaccf36aba5054c3631d1bdcb855718f5597609f"
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
    url "https://files.pythonhosted.org/packages/f2/40/f1e9fedb88462248e94ea4383cda0065111582a4d5a32ca84acf60ab1107/setuptools-rust-1.8.1.tar.gz"
    sha256 "94b1dd5d5308b3138d5b933c3a2b55e6d6927d1a22632e509fcea9ddd0f7e486"
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