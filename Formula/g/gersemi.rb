class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/5d/bc/0beae971dba37a69e4576ad3a184ac9f59003faf85cf19630738be0d041f/gersemi-0.25.3.tar.gz"
  sha256 "3eef90f46e959c5da6ed7257560269c42c34ebecc4d3d4551dbb5d9d46bc84b8"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e7fcf8e205bdebcee9e406d8f70b754d84746d5349ffc13afb20c313bb0b4b14"
    sha256 cellar: :any,                 arm64_sequoia: "afb5f0e4b3494e3184386477dfe0955b7e2832e4358f78e7d8c08f987779a1b5"
    sha256 cellar: :any,                 arm64_sonoma:  "ee14f1d7f47466cbc36eaa7b03239fa245a51385dbbf9de79526dd39892cbf29"
    sha256 cellar: :any,                 sonoma:        "0605d94460f5df284e0b9d7180a9465a6063e4f679653391d0c0992323197426"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f4c35882abdc51c5303b2a637d1be4b882b1d5853ae07cf750813713725cc3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "619796856c55a8e33dd7a7bec7c1a45c9f134c7526454b5d4b913fd0fd41a679"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "ignore-python" do
    url "https://files.pythonhosted.org/packages/5a/c1/39cfd73def936e6c9c06ae6227b314c90f7a57d725cf1cd15e3f576906c6/ignore_python-0.3.1.tar.gz"
    sha256 "a9c691ca0f5002391fc10c7d8c29859d38594b4751a5eb43f95b5a9f7bda30bc"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
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