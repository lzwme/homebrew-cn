class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https:cryptography.ioenlatest"
  url "https:files.pythonhosted.orgpackages0d0507b55d1fa21ac18c3a8c79f764e2514e6f6a9698f1be44994f5adf0d29dbcryptography-43.0.3.tar.gz"
  sha256 "315b9001266a492a6ff443b61238f956b214dbec9910a081ba5b6646a055a805"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https:github.compycacryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d732628afbbcc5bbecc5ed544f06f5b14d5ac6cc0a4c8b1f701c174358a4b847"
    sha256 cellar: :any,                 arm64_sonoma:  "0265f0b12dfa59e1d6a3536fd9bac94a2821008ec7bbafbd67942abf74461f46"
    sha256 cellar: :any,                 arm64_ventura: "9056aaceeb056bdc38281fa26cc8a489cda9bde496ed7abb2b010cdba3789f6d"
    sha256 cellar: :any,                 sonoma:        "df405e9244b4dcd5ad2851b9c1ec22002564ad54faa33527278edf2b6aacdb13"
    sha256 cellar: :any,                 ventura:       "c26185f2ba0fc8d47ce9ce50692d0f262c749268909fdee9f82753930185f850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e930f8ae8dc0cfcb56100239bb6dc2c34c07f7a4d17487546ce646aafe227d68"
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