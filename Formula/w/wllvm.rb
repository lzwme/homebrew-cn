class Wllvm < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for building whole-program LLVM bitcode files"
  homepage "https://pypi.org/project/wllvm/"
  url "https://files.pythonhosted.org/packages/4b/df/31d7519052bc21d0e9771e9a6540d6310bfb13bae7dacde060d8f647b8d3/wllvm-1.3.1.tar.gz"
  sha256 "3e057a575f05c9ecc8669a8c4046f2bfdf0c69533b87b4fbfcabe0df230cc331"
  license "MIT"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "162faf96612e2e8dfb52de0720628bfe1f005938ddd8609c46878585d90142e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "052784dfa3e4966812b3185e43b0bae847a9a4374628405886d99dc6a26d6462"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "825431e5d7a4e7648a225ad3cf8496451fc4023e28a932b479a373b832bbf85d"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e847b904217b3ff75d71b6fc93f2cb1fd876f9dde62350a55b0ba40a3c4f63c"
    sha256 cellar: :any_skip_relocation, ventura:        "4ce1a08acb570e729fbe54cceba7a823ab4b06e0dd309479de41bb6e661a33dd"
    sha256 cellar: :any_skip_relocation, monterey:       "effb678ca8c8e22c77f914183c0baab062282d1e1a4acd53d7a115157c400725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f6e082962d2128bf7909130811da0a85615d234a16c88a516f364c7a4e5b04d"
  end

  depends_on "llvm" => :test
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV.prepend_path "PATH", Formula["llvm"].opt_bin
    (testpath/"test.c").write "int main() { return 0; }"

    with_env(LLVM_COMPILER: "clang") do
      system bin/"wllvm", testpath/"test.c", "-o", testpath/"test"
    end
    assert_predicate testpath/".test.o", :exist?
    assert_predicate testpath/".test.o.bc", :exist?

    system bin/"extract-bc", testpath/"test"
    assert_predicate testpath/"test.bc", :exist?
  end
end