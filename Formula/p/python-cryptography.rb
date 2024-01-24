class PythonCryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https:cryptography.ioenlatest"
  url "https:files.pythonhosted.orgpackages1d95e81ad3a9caadfc6a4367de7432fd3b779a2e2af760ce9a9cb4f5704d57cacryptography-42.0.0.tar.gz"
  sha256 "6cf9b76d6e93c62114bd19485e5cb003115c134cf9ce91f8ac924c44f8c8c3f4"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https:github.compycacryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "104282e76fdfc7a28a81496eee122668afb81b4ae8ca46c6356ab8adaacfa188"
    sha256 cellar: :any,                 arm64_ventura:  "466d8e3e5d92eb12fbc05cbb70e076678359e4ac0d2e6dc1424d032eda444847"
    sha256 cellar: :any,                 arm64_monterey: "a58acb49f975167842a2a2883fb7fd3818c0aa2dce0fc86ccec0e3c04ce27ac9"
    sha256 cellar: :any,                 sonoma:         "b55e3bfaed61536885565fc2e4fbc8f423bf3639cccf10a9f0bb55fbef5a8e42"
    sha256 cellar: :any,                 ventura:        "24f52ee6651bfd37bd268680d5836abf77bfae7d0f4763e49aaa679c56a0f1f2"
    sha256 cellar: :any,                 monterey:       "62d01f50ab958a2b7f7662be4920631ad19ce54f59a7b5583d1892e8afcd635b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71702aa71c0868930388315528aacf93a8de86b503b151210ee1e6f15c984a1c"
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