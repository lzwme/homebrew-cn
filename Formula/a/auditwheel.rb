class Auditwheel < Formula
  include Language::Python::Virtualenv

  desc "Auditing and relabeling cross-distribution Linux wheels"
  homepage "https:github.compypaauditwheel"
  url "https:files.pythonhosted.orgpackagesce12af339761d80296e76033669e4179883108d8a7d79bb032bd58427a2b4485auditwheel-6.1.0.tar.gz"
  sha256 "3bdc686e774cf9e355e924b0fe5a562d55caa385d72234ffe7b81b378dba360f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "912cbfe2eb42c61be96f76144f77980e2f7c651fc12deedcc21512c6fdd64b63"
  end

  depends_on :linux
  depends_on "python@3.13"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackages88560f2d69ed9a0060da009f672ddec8a71c041d098a66f6b1d80264bf6bbdc0pyelftools-0.31.tar.gz"
    sha256 "c774416b10310156879443b81187d182d8d9ee499660380e645918b50bc88f99"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}auditwheel -V")

    resource "homebrew-test-wheel" do
      url "https:files.pythonhosted.orgpackages4c00e17e2a8df0ff5aca2edd9eeebd93e095dd2515f2dd8d591d84a3233518f6cffi-1.16.0-cp312-cp312-musllinux_1_1_x86_64.whl"
      sha256 "2d92b25dbf6cae33f65005baf472d2c245c050b1ce709cc4588cdcdd5495b520"
    end

    resource("homebrew-test-wheel").stage testpath

    output = shell_output("#{bin}auditwheel show cffi-1.16.0-cp312-cp312-musllinux_1_1_x86_64.whl")
    assert_match "is consistent with\nthe following platform tag: \"linux_x86_64\"", output
  end
end