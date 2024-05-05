class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https:cryptography.ioenlatest"
  url "https:files.pythonhosted.orgpackages34c0d55779ee5c35d77088ca75a721c991dcdd9879e68cde5a3b5b3ac91f0a86cryptography-42.0.6.tar.gz"
  sha256 "f987a244dfb0333fbd74a691c36000a2569eaf7c7cc2ac838f85f59f0588ddc9"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https:github.compycacryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0c9191e4fb27b78be441615f8b56570d08d90565b092f0d456c8e0e07b6131da"
    sha256 cellar: :any,                 arm64_ventura:  "c8e057d051023a4acdc1f14a2ca2973c98e75fa53759295f489b35bf139ea622"
    sha256 cellar: :any,                 arm64_monterey: "1f4862e8f09d2a8f2cdc100e487adcc464c7f2f5f0cc27c268af4e9e60b4aee6"
    sha256 cellar: :any,                 sonoma:         "e988b06e057da7b96a2ffc564ac8e21fa5159483177c93dca0833d0421bfd89b"
    sha256 cellar: :any,                 ventura:        "ce3e09475e06ba8abd06b29758d4e890dc58c223f011a0dce5981f3619aedb7e"
    sha256 cellar: :any,                 monterey:       "6e885f9045a725683f6698ff9e152d2600c3a687daef95427a706d5b11b8f818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09ab7e7169eeb3b878424ab2b96577cbaf84d2f4d6fa4eac8fa12a8ecc882d95"
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
    url "https:files.pythonhosted.orgpackagesd64fb10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aedsetuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  resource "setuptools-rust" do
    url "https:files.pythonhosted.orgpackages9df12cb8887cad0726a5e429cc9c58e30767f58d22c34d55b075d2f845d4a2a5setuptools-rust-1.9.0.tar.gz"
    sha256 "704df0948f2e4cc60c2596ad6e840ea679f4f43e58ed4ad0c1857807240eab96"
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