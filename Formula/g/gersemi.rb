class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/4f/dd/c791442e6cc4279b14b7d54ca31c9824a5e0f8b7c9d11e738430fccbde00/gersemi-0.25.4.tar.gz"
  sha256 "834b68e663f746d2c0af54bd9bd573ae02306b76be87ab180c52c05a1b403206"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4a14a304bc6c31f83c293466580c90f6b7ef2d378d817a250a40d89b3eb3388"
    sha256 cellar: :any,                 arm64_sequoia: "e89cc4677ceb0030d3987bee99a988603eefa1148e2e9a6a07cb1b13e029cea0"
    sha256 cellar: :any,                 arm64_sonoma:  "34f8954545512ef8006e0f8084ba565f0527c1ed45d07433d7f5ca8e765a7be1"
    sha256 cellar: :any,                 sonoma:        "156694580a2f961b53aee318a7e577e5c06f01707ccb28a8faae5162f0782b61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c518ac2bd8270d607ddce1953aa1ef935c52bdb8054b3423938cf1c63964da0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb775d4be68f6aec722ef31f7496c3c231c657ce77a0e70926432d943e585645"
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