class PythonCryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https:cryptography.ioenlatest"
  url "https:files.pythonhosted.orgpackages139ea55763a32d340d7b06d045753c186b690e7d88780cafce5f88cb931536becryptography-42.0.5.tar.gz"
  sha256 "6fe07eec95dfd477eb9530aef5bead34fec819b3aaf6c5bd6d20565da607bfe1"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https:github.compycacryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3815c4c29e9c4b06d168f6a099de110b21589f1328002bbb69cabfe74833f8db"
    sha256 cellar: :any,                 arm64_ventura:  "88fce207c4309700c2b72603a58700df37bef9794032129664093df3461776fb"
    sha256 cellar: :any,                 arm64_monterey: "a04242850e1f1a95a56fd448c36afaba92dcaf9ab39ae4d3c355319237684e1e"
    sha256 cellar: :any,                 sonoma:         "f37e9ff879eadcaf5c0436081b98f3b0f06f0175478b6c259cda45dccd97a601"
    sha256 cellar: :any,                 ventura:        "2baefbf70fded94cfb40545756d0adf2b1e9bd46a65692ff8004ed6dec898031"
    sha256 cellar: :any,                 monterey:       "0ecc541040522ea207714de3c1060b8c8d65a259526282a2dbd86cba230c1734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b19a34f39e6d676611a6a986d878df3ef932143e5af208850fef0a64d013274"
  end

  depends_on "pkg-config" => :build
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
    url "https:files.pythonhosted.orgpackagesc81fe026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
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