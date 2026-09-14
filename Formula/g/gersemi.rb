class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/ab/81/312386da943216127cfea5646a5f3e329afa27c6b777b35a41592a76f6bd/gersemi-0.29.0.tar.gz"
  sha256 "6b6a41bea5fce42033d6330aa2a202b3564b44475050e26c03d65c44e1e3c05d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a59db71f24dbc549a53687f5e8c60c245d519481f0d5b401122ab27a704aede7"
    sha256 cellar: :any, arm64_tahoe:       "9017b2b715553701cf327b8f5b2e10e7eeb38314c746cae26130b964e48b9159"
    sha256 cellar: :any, arm64_sequoia:     "0323949c016930661fd4271e0f67970ae0e157836ff1c64a44d867539dc882c8"
    sha256 cellar: :any, arm64_linux:       "646985250c83052c7c816a07698880b135eae1b7afa5ad99788433bfcffe0fbb"
    sha256 cellar: :any, x86_64_linux:      "bdfb085739cbcbfb5613d2c6122c218663f2152fdbe946cdd0a6407fed68ab2f"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

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