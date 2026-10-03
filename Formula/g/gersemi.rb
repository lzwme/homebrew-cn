class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/65/6a/278112b2d82169bfe6bd2bac025deb917d7c83f890d71509c988fedd9a01/gersemi-0.29.2.tar.gz"
  sha256 "3acab643bec6c8174fb90ece56d76a8381847f77873a1a6ae3211f5b40472c25"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "64fe8b22b13468205e40e720e1f224a2657da604ef6d0609e5a29d31c3c07787"
    sha256 cellar: :any, arm64_tahoe:       "ed99cdb7443d123c9f6cf50296a206768a0b04a1ef404ddddaf52c29edd86ecb"
    sha256 cellar: :any, arm64_sequoia:     "4aeea171054d6ef8f5d5e27ce8cb9f5302d4fa1f3e54d502c6bddb283114c4a1"
    sha256 cellar: :any, arm64_linux:       "8344877d5ea28103c865848fdb3218dacea504fce59718fef250e002efa50a82"
    sha256 cellar: :any, x86_64_linux:      "19f69b9b77d70a950400d4f9f9e5c1c0adc58d83878ac4d1c01ac82adec61636"
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