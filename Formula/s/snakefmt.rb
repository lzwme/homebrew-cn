class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/8e/0a/ce930eafdc3ea5999c6fd65cb473c33a3f310606907e6de0241ec5e5f149/snakefmt-2.0.0.tar.gz"
  sha256 "a47259b1fcd958b73e59052e2425708240652b7b2f9ff7d6b2b14d2894f10b33"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30d133d7984f9699d9371ad07e24baab7d657b3341bee5958e97114b57f58ee1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2a6cd4a26497e0cb0c6ad9f8962dc4b08b906dfb311a781799bb46e2d6d6c86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9402af89eab8dc3c4fd4fd7560e4cfdfca3e9fa36d83b2fc6c134f94fefb8cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e96ec5bd4cc90bd905d1625cceb4af49bcfc8ec4fcf220ee395dd2b0c9cc7ce9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b6f3c5e5017156ceac7bbf8191b8d69961cae68ef30d6f96a7e937fba469273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "512f0fde8ddccea35be59bc406a72833920ee813561bcaf171ae898643ddfe37"
  end

  depends_on "rust" => :build # pytokens -> mypy -> ast-serialize
  depends_on "python@3.14"

  resource "black" do
    url "https://files.pythonhosted.org/packages/c0/37/5628dd55bf2b34257fc7603f0fe97c40e3aaf24265f416a9c85c95ca1436/black-26.5.1.tar.gz"
    sha256 "dd321f668053961824bcc1be1cc1df748b2d7e4fa28086b08331e577b0100a73"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/23/e4/796662cd90cf80e3a363c99db2b88e0e394b988a575f60a17e16440cd011/click-8.4.0.tar.gz"
    sha256 "638f1338fe1235c8f4e008e4a8a254fb5c5fbdcbb40ece3c9142ebb78e792973"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/b6/34/b4e015b99031667a7b960f888889c5bd34ef585c85e1cb56a594b92836ac/pytokens-0.4.1.tar.gz"
    sha256 "292052fe80923aae2260c073f822ceba21f3872ced9a68bb7953b348e561179a"
  end

  resource "shfmt-py" do
    url "https://files.pythonhosted.org/packages/06/d5/c2ad5c6593a34da7344cf39bde65763e8cda752589074ba1619e55b317ad/shfmt_py-4.0.0.tar.gz"
    sha256 "1e5fdacf40aabaa77a97639d52a6220df0893b46658d82b7f136f4e66e2b2fb0"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"snakefmt", shell_parameter_format: :click)
  end

  test do
    test_file = testpath/"Snakefile"
    test_file.write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}/snakefmt --check #{test_file} 2>&1", 1)
    assert_match "[INFO] 1 file(s) would be changed 😬", test_output

    assert_match "snakefmt, version #{version}",
      shell_output("#{bin}/snakefmt --version")
  end
end