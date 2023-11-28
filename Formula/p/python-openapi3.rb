class PythonOpenapi3 < Formula
  desc "Python3 OpenAPI 3 Spec Parser"
  homepage "https://github.com/dorthu/openapi3"
  url "https://files.pythonhosted.org/packages/94/0a/e7862c7870926ecb86d887923e36b7853480a2a97430162df1b972bd9d5b/openapi3-1.8.2.tar.gz"
  sha256 "a21a490573d89ca69ada7cbe585adb2fca4964257f6f3a1df531f12815455d2c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a112fb67188c46fb9b5f2ba9549091b9c3b321fdc8d12a79b866b4db0f8d3d7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fd0e0b59b514789b8569449e5fce95e18f5cdd3bf8a1fb2114e776934520b86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a38ff10ca1a84afaaf438e1b04bb8e65d60764cf582a4e911aeb2e2d2b33980"
    sha256 cellar: :any_skip_relocation, sonoma:         "feb33e8a9c91789d6f3082a9b7672590ca08821dd6192ffd2617f8a868a609ed"
    sha256 cellar: :any_skip_relocation, ventura:        "d9a8eece41081aa5b7fad9ad4598e828e11c02bc5f41550b7527911101f3de31"
    sha256 cellar: :any_skip_relocation, monterey:       "000c2f82cceaeafa7dd7bcea25f21c867e09194c9256c3909bfb41af421bb06d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ea13b0db9347b7bf2e017fe9556d61946b53a011194c18e262a1629d49d82bb"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-requests"
  depends_on "pyyaml"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from openapi3 import OpenAPI"
    end
  end
end