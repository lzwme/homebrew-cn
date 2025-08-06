class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/f3/53/cf2486091560f08c66a6ceda2c56647b413fd6ed25138a584d0c685f2192/gersemi-0.22.1.tar.gz"
  sha256 "9679d801f7293d162201bffae860707ca5a53f35c9f0063f62f5cbb834f66da8"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "03f63afed76c99c112b6cb2d9da9104f14f168628f9a43193a28de31e7da3622"
    sha256 cellar: :any,                 arm64_sonoma:  "e8dabaaa4d17a884e611e322c394fe8b0a756892a16bd34324cd8574fbdcb607"
    sha256 cellar: :any,                 arm64_ventura: "0832a836773d60f773e844d9edf9a2cf39dfa5cb00b0b175650272cc94578a50"
    sha256 cellar: :any,                 sonoma:        "f9a6862f50e925402be6fac0383eef1fbd2daf1bd6467e250edefae1a99ded6d"
    sha256 cellar: :any,                 ventura:       "50ccee355ab290740ad284fecf0ea7b728622c73e6b418b956b211bbf16b9979"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "778167d99171af646cd1fda467a83da7b936ba1b4b9a4691143c267f1bfeea1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68da557f1e2d6ffff01e839f1c724c7ac833e958b23f1c24f8ec722e9d81933b"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/af/60/bc7622aefb2aee1c0b4ba23c1446d3e30225c8770b38d7aedbfb65ca9d5a/lark-1.2.2.tar.gz"
    sha256 "ca807d0162cd16cef15a8feecb862d7319e7a09bdb13aef927968e45040fed80"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gersemi --version")

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    # Return 0 when there's nothing to reformat.
    # Return 1 when some files would be reformatted.
    system bin/"gersemi", "--check", testpath/"CMakeLists.txt"

    system bin/"gersemi", testpath/"CMakeLists.txt"

    expected_content = <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    assert_equal expected_content, (testpath/"CMakeLists.txt").read
  end
end