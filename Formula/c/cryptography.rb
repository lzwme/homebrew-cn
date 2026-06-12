class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/12/45/870e7f4bef50e5f53b9f51d4428aee5290eedf58ba443f16b1ebb7ab8e66/cryptography-48.0.1.tar.gz"
  sha256 "266f4ee051abb2f725b74ef8072b521ce1feacf685a3364fa6a6b45548db791a"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  compatibility_version 1
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fa249bbd5e0d89c5497bb295faf17fe14f9f403f1205a8b647171cd68dc8614f"
    sha256 cellar: :any, arm64_sequoia: "1e39c60c625a9ca614205b785f5a9cb585b92a3774680d16bb435623d07bcb9a"
    sha256 cellar: :any, arm64_sonoma:  "65979c5813365a3951454c0dac6dc1e09da56ef73ea03fadc534008f2cf482a0"
    sha256 cellar: :any, sonoma:        "58efaad255cd7d09f7f8211fe8eaf54cfdedfbff542d7a1f1166662b1ab13a46"
    sha256 cellar: :any, arm64_linux:   "9c3ce95d4f9b0d91f9dffb3dd6666a0aed37f838697db6385845236ecfd72431"
    sha256 cellar: :any, x86_64_linux:  "32eb0f1b7592027cad7b41e8eeccbf9fbe73ab36a90efb3b56ba6691f6f5bc2f"
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