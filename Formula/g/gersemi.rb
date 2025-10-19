class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/e7/de/baafb537f824e0585561b70d7cf896a876e7c699887dec945a9c527e02b6/gersemi-0.22.3.tar.gz"
  sha256 "ae764e726ed2e9cefd696dc0f082fff77e2e51dd236c61739b18fee69fe406f4"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2103ed81a05f766725993411ed571328c4ecd6ee2999c5be92ff2d50445ca0d3"
    sha256 cellar: :any,                 arm64_sequoia: "9b26db5689a43e2e27de764da8996248c0ae87e9c61d0fb31eb97b7c528acf71"
    sha256 cellar: :any,                 arm64_sonoma:  "6971e7695d68cf2ba80e726e87ba422736e63ad454c5f5a6cb47d5030941c45e"
    sha256 cellar: :any,                 sonoma:        "0734180a291b16240e7749040e504d36a45b2c55810bc776c2dbfb70d41bee7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "233f3c1e8ead8e6c3c183552ad606d4bedc3e6f524daed4459ba1c0ce576f11f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3338770c35c0dbb5411cc24c3841974e85b7dc385913ad55d2377b31bda1a831"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/1d/37/a13baf0135f348af608c667633cbe5d13aa2c5c15a56ae9ad3e6cba45ae3/lark-1.3.0.tar.gz"
    sha256 "9a3839d0ca5e1faf7cfa3460e420e859b66bcbde05b634e73c369c8244c5fa48"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
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