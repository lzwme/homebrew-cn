class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/96/07/0b55f2e06b8f2eb6c01afd77e4b91cbea312ae05ead93f1526e7ef7cc3f3/gersemi-0.23.0.tar.gz"
  sha256 "ef69219e1a8b97e6b920c601637f4ad6bf8d4fdceb8e9edc4203fa50115fab65"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0797519925b884a101dc09be11ae38fbf85394736fa379114fdef3e4a2c92e2e"
    sha256 cellar: :any,                 arm64_sequoia: "97a171b2251ab115920c06008c92eea5f98d845cfd22990fc57996ba2fc9dc1e"
    sha256 cellar: :any,                 arm64_sonoma:  "20512667d93a275b62b8406f47e98381e4bb9b5e3f3efc2faa51b09532d0079e"
    sha256 cellar: :any,                 sonoma:        "ef2827b0ba0303c0a5f25a2644010d2c2248987bc78526de0615d6a6c5c43090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "620e9b050d3fa0c18c4e9bdb42260fcdedc1cbfafee6a52aeb501b799a325c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee9a4d46ca5ca0fef9f6a4ef77394971edc1af55bf3e356f0c22874d8c5df4a1"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
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