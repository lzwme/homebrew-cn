class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https:cryptography.ioenlatest"
  url "https:files.pythonhosted.orgpackagesdeba0664727028b37e249e73879348cc46d45c5c1a2a2e81e8166462953c5755cryptography-43.0.1.tar.gz"
  sha256 "203e92a75716d8cfb491dc47c79e17d0d9207ccffcbcb35f598fbe463ae3444d"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https:github.compycacryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6f26be8218b1fc85c08b076a3c3da06b685825751fa039127e69b6ea02120bd4"
    sha256 cellar: :any,                 arm64_sonoma:   "637373486e9a791bb115d369329f4249266893106fe54fe532bd5bd9a306758d"
    sha256 cellar: :any,                 arm64_ventura:  "40b6184167f35f9b7e1088df850a813044882eaf3c8007f3cc04e48a191fafa2"
    sha256 cellar: :any,                 arm64_monterey: "c412b8a6e300a95333a151d60551774383cde0f717d196cb2f2bf2bc8257140d"
    sha256 cellar: :any,                 sonoma:         "90b17c05aad76724d3d8b1cd3fd18b765911b34d7abcadd09e98681c17581d0f"
    sha256 cellar: :any,                 ventura:        "5c2ade6777251ed43998efd39c1c3869205ceb50d5086b1333e7a15ee8c18cab"
    sha256 cellar: :any,                 monterey:       "d9ba8d1fc9306edabb94b5fe4ef46694dc110af6846c2a933acf776570c8f546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d1ef4342de33eeb4c6d4bd4653ba1463611d9592bf4e3570a7fc4a2e9fbfb01"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  resource "maturin" do
    url "https:files.pythonhosted.orgpackages1dec1f688d6ad82a568fd7c239f1c7a130d3fc2634977df4ef662ee0ac58a153maturin-1.7.1.tar.gz"
    sha256 "147754cb3d81177ee12d9baf575d93549e76121dacd3544ad6a50ab718de2b9c"
  end

  resource "semantic-version" do
    url "https:files.pythonhosted.orgpackages7d31f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages27cbe754933c1ca726b0d99980612dc9da2886e76c83968c246cfb50f491a96bsetuptools-74.1.1.tar.gz"
    sha256 "2353af060c06388be1cecbf5953dcdb1f38362f87a2356c480b6b4d5fcfc8847"
  end

  resource "setuptools-rust" do
    url "https:files.pythonhosted.orgpackagesb8864f34594f21f529623b8650fe729548e3a2ad6c9ad81583391f03f74dd11asetuptools_rust-1.10.1.tar.gz"
    sha256 "d79035fc54cdf9342e9edf4b009491ecab06c3a652b37c3c137c7ba85547d3e6"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec"binpython" }
  end

  def install
    ENV.append_path "PATH", buildpath"bin"
    pythons.each do |python3|
      ENV.append_path "PYTHONPATH", buildpathLanguage::Python.site_packages(python3)

      deps = %w[setuptools setuptools-rust semantic-version maturin]
      deps.each do |r|
        resource(r).stage do
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