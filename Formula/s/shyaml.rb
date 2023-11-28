class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/b9/59/7e6873fa73a476de053041d26d112b65d7e1e480b88a93b4baa77197bd04/shyaml-0.6.2.tar.gz"
  sha256 "696e94f1c49d496efa58e09b49c099f5ebba7e24b5abe334f15e9759740b7fd0"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/0k/shyaml.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b46bc1af5f896c10e67be0d37ca5fb830f9b4b8ca836767cf08f252977910be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ceb01b2b4f42730b98fb82d286b75d3561e2de2bd9f1ac983b084bf23ed5ab0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87e092771c2c63b1a2570b19d240772d32ddedeaf1e54b29ce5291e21f226a36"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b30cf0dbf0da3d6c0a438d56ef85196cd9aa0542811bfdb0747f55a1cf74159"
    sha256 cellar: :any_skip_relocation, ventura:        "16bbdf708763e764bbe770beb115144ffaf4043227fb0716e0c0e1257356e9f3"
    sha256 cellar: :any_skip_relocation, monterey:       "ad208ce49424ec294458cba3192b9e04f7ff8f9665ca92cb73d1184f0ba65d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b372f564fbc35d834bce20b9ed36af9f3a5e7bab5cb4895c09425691aa44fa2"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"

  def install
    # Remove unneeded/broken d2to1: https://github.com/0k/shyaml/pull/67
    inreplace "setup.py", "setup_requires=['d2to1'],", "#setup_requires=['d2to1'],"
    inreplace "setup.cfg", "[entry_points]", "[options.entry_points]"
    virtualenv_install_with_resources
  end

  test do
    yaml = <<~EOS
      key: val
      arr:
        - 1st
        - 2nd
    EOS
    assert_equal "val", pipe_output("#{bin}/shyaml get-value key", yaml, 0)
    assert_equal "1st", pipe_output("#{bin}/shyaml get-value arr.0", yaml, 0)
    assert_equal "2nd", pipe_output("#{bin}/shyaml get-value arr.-1", yaml, 0)
  end
end