class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/4b/bb/4575396af9c5f7d702e0f133d4a21f3986b994d2aa62ec8c9f4a271262d1/gersemi-0.27.3.tar.gz"
  sha256 "ef17dd04d5683220a576915ec5d25ebba19d4e5ff1b85c4763ae7bf1abe34c9d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1951dc0320e29cc73435f3c9684f86c2d2908b4808e4fd0baa6534938e3716a0"
    sha256 cellar: :any,                 arm64_sequoia: "24fb0eedc86e001f5cd3fabdd0e0777c0d0b6ef418fa432066d065b492798102"
    sha256 cellar: :any,                 arm64_sonoma:  "905fb3454cc1bec16ec51f46fa4038ae1af23357d60dea1b3deed12c6008d1c5"
    sha256 cellar: :any,                 sonoma:        "2b4a287c5aef71fa2ae072c9046100104e3ffa9c63160ace0f6d3faf0af10e9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e5e2bb6b55fae00268267b769d9f99b8029db168c4ca647acee276b3348352f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d066f145f025081477e953624af4afb22cdcc7d79157dcc1490eeeb93562a74"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "ignore-python" do
    url "https://files.pythonhosted.org/packages/f4/4a/37928a560a345c6efb207452cf81d3c14f25a6d83df0fa5a00752c0c912b/ignore_python-0.3.3.tar.gz"
    sha256 "dc80ac80ace112da6d02f44681b6beb2ccecb68d6ac2b5e1b82d7f84347e1cf6"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    ENV["CARGO_VERSION"] = Formula["rust"].version.to_s
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