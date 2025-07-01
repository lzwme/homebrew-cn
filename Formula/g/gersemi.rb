class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https:github.comBlankSprucegersemi"
  url "https:files.pythonhosted.orgpackagesbf9ba33471928f0ec2524328e4cccba8558a7fd44af183bad65c8d3445bb05cagersemi-0.20.0.tar.gz"
  sha256 "023be6edbb7c7279f49e8347cfc003c9fb261a2338a73a7896000059e71cdecc"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f6453afa88df35b5c05df1abbddef7a371eb0e172a63d6d2c5ca752622ca63b1"
    sha256 cellar: :any,                 arm64_sonoma:  "9a9215737591ba1fcab4b265f1698a4cdc055475e0efb5c6a011cf43f54b8ea0"
    sha256 cellar: :any,                 arm64_ventura: "4b91b3a85e14d083b6dd3d43a12e017e3bb2e92dd586f1a37536df0ced78315c"
    sha256 cellar: :any,                 sonoma:        "b107734373eed91beca95c8f7ca30fa8fb10c4401c7dbeb636f4151893f5eef7"
    sha256 cellar: :any,                 ventura:       "aab8ab350cc6ecb782ec35d9c4b28d2402ee76ce7ba1bdc14fce0d35698f9a8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09813c446490eefa24ac6ef68fef874d3670f705180ed05354f329b3faa6c7e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "060789d26c416d70821636a379c51bd12ff34f141d7edc09009e47f7c3c86eed"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "lark" do
    url "https:files.pythonhosted.orgpackagesaf60bc7622aefb2aee1c0b4ba23c1446d3e30225c8770b38d7aedbfb65ca9d5alark-1.2.2.tar.gz"
    sha256 "ca807d0162cd16cef15a8feecb862d7319e7a09bdb13aef927968e45040fed80"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gersemi --version")

    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    # Return 0 when there's nothing to reformat.
    # Return 1 when some files would be reformatted.
    system bin"gersemi", "--check", testpath"CMakeLists.txt"

    system bin"gersemi", testpath"CMakeLists.txt"

    expected_content = <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    assert_equal expected_content, (testpath"CMakeLists.txt").read
  end
end