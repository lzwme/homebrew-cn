class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a4/ba/04b1bd4218cbc58dc90ce967106d51582371b898690f3ae0402876cc4f34/cryptography-46.0.6.tar.gz"
  sha256 "27550628a518c5c6c903d84f637fbecf287f6cb9ced3804838a1295dc1fd0759"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  compatibility_version 1
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6fb78284f0fb15ace521bf4438b7ed593d4b10d9b1a4dec134d0de5f2747ff6e"
    sha256 cellar: :any,                 arm64_sequoia: "a57b25431406a6e4669db824b667a2f78ba36eb5c62c077910653ddf49ecb434"
    sha256 cellar: :any,                 arm64_sonoma:  "ab74425942b4af43063bf8e992ec3fc0ad0fb286cae90c3b48c819b254dc3e19"
    sha256 cellar: :any,                 sonoma:        "5f5b09a1b4bf70d7b7e8f9e052c615e662595c4a67e54617dfadf29cc5ba3b36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5df02cb10a770d1527b22373a1ffc362307f17d8179ad4181dd759b7e4184b7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d27259cd805040592053d53d30174d86c61f038ebec67b439d019ebe5780136"
  end

  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  pypi_packages exclude_packages: ["cffi", "pycparser"]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    # TODO: Avoid building multiple times as binaries are already built in limited API mode
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~PYTHON
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