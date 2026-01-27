class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/46/ca/1df4b415613f59824137b191fcaf5180b3abd3f36467e56c7e1dc6c0a6d2/gersemi-0.25.2.tar.gz"
  sha256 "ea58c4022a3ee2b96ab2004bb4ea125b9d9e612969ecb8747c0258c69610a4c4"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c4d28635c9ef1b44f0f36b6ad793b8a66c7d5aa3392a203b141b4b2ca9315e4e"
    sha256 cellar: :any,                 arm64_sequoia: "c79b8b3aca7950e025a8e7e71ff6d17d44b5b7ea409e0ca548b383caa51d6eda"
    sha256 cellar: :any,                 arm64_sonoma:  "e578fa5d73570a6970571f2175e37a56a45da70ed8634b8dc6585c8320d513a5"
    sha256 cellar: :any,                 sonoma:        "68015eb60b835adf9357bc7b04d612ce74ead57052f607dc97b8446d7ff78033"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "791cab54172bc05ca6da7516c53a8a40d0bc7bcb902af41ed1db979b7254cd96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b303ae0694b40f973fbbcdd4d44f98acd5005f99a9bf6b168dfdc1caa0a948f"
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