class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/b6/0d/c382f92b3cdc131ca0ef2b51de91e3ef36498ab53005773c5c467e543cd5/gersemi-0.27.5.tar.gz"
  sha256 "d8b70087243946539f73077d75a20c66d16ef12614f3c5e1dacee25ec9762d6a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e654f21c78928494a112dd460d80047c195dcbc607bea7a3f076f14d24ebc76b"
    sha256 cellar: :any,                 arm64_sequoia: "f598f8a6e581b14f85a9f38fdcef6a66b14fa4ee633f5b7c12771d62fe6359a4"
    sha256 cellar: :any,                 arm64_sonoma:  "a44d30615325d5002ff2bfb6bc57c4706d6f7055888f810531e57015a78901cb"
    sha256 cellar: :any,                 sonoma:        "4937893031261f795fe5124d9651ba824e4099d972114cf4da227d508e83bc4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fac2965b536d339228f26184f0c79947adfef7761f249b07a56527c53efdee8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d0dd9816b66da977fd7b1ddc83dcfdb53293a61e78a6947531116f8c5f4ae09"
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