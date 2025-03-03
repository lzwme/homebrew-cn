class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/61/7e/79e07dc2eb8874580934cd0c834a8a78f15d5b0d6155a424f6c7b35441c3/scons-4.9.0.tar.gz"
  sha256 "f1a5e161bf3d1411d780d65d7919654b9405555994621d3d68e42d62114b592a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "151c811ed2fb8f49ded747f540963eeb0c9e0709791e4f19de0fe3fef97dc88a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "151c811ed2fb8f49ded747f540963eeb0c9e0709791e4f19de0fe3fef97dc88a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "151c811ed2fb8f49ded747f540963eeb0c9e0709791e4f19de0fe3fef97dc88a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4e4aac6930d155026974edde3bf8a1d4784794d55afc7d6715efdad9fb8a407"
    sha256 cellar: :any_skip_relocation, ventura:       "c4e4aac6930d155026974edde3bf8a1d4784794d55afc7d6715efdad9fb8a407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "151c811ed2fb8f49ded747f540963eeb0c9e0709791e4f19de0fe3fef97dc88a"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    C
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end