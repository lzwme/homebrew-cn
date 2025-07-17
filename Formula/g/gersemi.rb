class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/8a/be/c8a70292903d598efdb33cf532c1b680ddd62dabd248f1c5d26555df3dd1/gersemi-0.21.0.tar.gz"
  sha256 "b22808035a5f1bfb7e961a26feb2eb88d66c42d4bd0aab73bad017cf11d85bf2"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f77c6e6ceea641019518236501f5b31d76684cb214e66d22149526b2c30ffdc6"
    sha256 cellar: :any,                 arm64_sonoma:  "974b9ac195d5fffec6012eed6be09488a225b48534f09d7a75cf31a0bbfc70c9"
    sha256 cellar: :any,                 arm64_ventura: "73bb8e39eed809454118ad45120f0292124c0c0e23e763baf5a528f3d9347a8d"
    sha256 cellar: :any,                 sonoma:        "341e4c377a577a91d44c5c0f40883b9e76f88d5a568602cb6caa44f8a3ae115b"
    sha256 cellar: :any,                 ventura:       "75c3a2f9cb70228be45afb278118572c54c16deb46d451a02f35c74581e58ce1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ee511c8bb1e46b88f08a3376a35e290237d9b68fb3fddb3fbee6ecc9a8f5a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3939af1048f9812bbcc1b7c18a34deee73bb6e6dac707ae9b349e7ca715ef4d2"
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