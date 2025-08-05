class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/a7/a4/1bce8aefbfa2f30a22f64b44075385cacb74a8e645ca86be5f28f689b7a9/gersemi-0.22.0.tar.gz"
  sha256 "257ca8bc8fc578996aeb90b510f7a6439240e62251177c4873c9453728db321e"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d829a3ee5133ca6be3dcf8c4bad8eb71276d3417d5e38ac4003bffbcd9ffd55"
    sha256 cellar: :any,                 arm64_sonoma:  "f81397ff2c23da0c7a267c9b707ecb75a249af1b9eaa4b2eedf9268448369bac"
    sha256 cellar: :any,                 arm64_ventura: "eddfd4c65fd91643cfcba84d041b3b882d25ef0c1cf741531cecab79adc0d7d1"
    sha256 cellar: :any,                 sonoma:        "c6a5bec2c63f944a2c11232f856ee6ff96141a79394a1692fd793227d53466a0"
    sha256 cellar: :any,                 ventura:       "782b059c3b9c249e8285d2b6604750e518bc9386d4234f3c35938f8bb617bd37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a37cb89ccdd315e0716e0d569f6e9208b81c9da7bc0a2f41dedc4f29c87d87be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d49a50d262395d0d2ffc9fd8b36f3956951a804a121d2a1ea7de3b0888d7e2fa"
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