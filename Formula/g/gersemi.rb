class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/60/74/349a9dd2d890787aba7ea00fa8c54f12f4b006cc84a37e6e9a02fc07684f/gersemi-0.27.0.tar.gz"
  sha256 "39fd89642c060d604a20330302721372be7b0987f0bfb53b2b2d2e96abd28bac"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8ee8ad9b67eb877bbe30999627decdb6b83b03233d0ec8f24d03dda82f26d9d4"
    sha256 cellar: :any,                 arm64_sequoia: "486d00cfd463ce14a0af7e7d3fe08dd6a2831cd2ac5572bece28c3c606ffe1d3"
    sha256 cellar: :any,                 arm64_sonoma:  "a027954ae85d9faf8e15fef7bc76565f976fdce19ddcbc1d89f10a366e594f8e"
    sha256 cellar: :any,                 sonoma:        "07a8a8b408acd2fa0e86b9239246de9a347f8bff878375251ea3900f476762b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c8838c5f1afa6f5813915f0dee100fbb8421664234e46779c8487382b76341f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01eacb5af66251c1b09ac4b10dcad7ecbf8c747f2a8045a529526228fe01ae9e"
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