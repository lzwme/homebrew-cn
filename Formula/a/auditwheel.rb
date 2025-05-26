class Auditwheel < Formula
  include Language::Python::Virtualenv

  desc "Auditing and relabeling cross-distribution Linux wheels"
  homepage "https:github.compypaauditwheel"
  url "https:files.pythonhosted.orgpackagesfbf3b61e3b5ccceee2c25baff6c16146d031f6f5c75b1c09d598bfbfe498adecauditwheel-6.4.0.tar.gz"
  sha256 "20990ccb2416fdb81983ef654d10df72f9f25b388e30105bc3d97b06d6aecafb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e46bbb1c73158a8ad508e7197f7d07c8625906d776efe6f86796c81463c3ed80"
  end

  depends_on :linux
  depends_on "python@3.13"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackagesb9ab33968940b2deb3d92f5b146bc6d4009a5f95d1d06c148ea2f9ee965071afpyelftools-0.32.tar.gz"
    sha256 "6de90ee7b8263e740c8715a925382d4099b354f29ac48ea40d840cf7aa14ace5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}auditwheel -V")

    if Hardware::CPU.intel?
      resource "homebrew-test-wheel" do
        url "https:files.pythonhosted.orgpackagesf147d7145bf2dc04684935d57d67dff9d6d795b2ba2796806bb109864be3a151cffi-1.17.1-cp313-cp313-musllinux_1_1_x86_64.whl"
        sha256 "72e72408cad3d5419375fc87d289076ee319835bdfa2caad331e377589aebba9"
      end
      platform_tag = "musllinux_1_2_x86_64"
      wheel_file = "cffi-1.17.1-cp313-cp313-musllinux_1_1_x86_64.whl"
    else
      resource "homebrew-test-wheel" do
        url "https:files.pythonhosted.orgpackages5fe4fb8b3dd8dc0e98edf1135ff067ae070bb32ef9d509d6cb0f538cd6f7483fcffi-1.17.1-cp313-cp313-musllinux_1_1_aarch64.whl"
        sha256 "3edc8d958eb099c634dace3c7e16560ae474aa3803a5df240542b305d14e14ed"
      end
      platform_tag = "musllinux_1_2_aarch64"
      wheel_file = "cffi-1.17.1-cp313-cp313-musllinux_1_1_aarch64.whl"
    end

    resource("homebrew-test-wheel").stage testpath

    output = shell_output("#{bin}auditwheel show #{wheel_file}")
    assert_match "is consistent with\nthe following platform tag: \"#{platform_tag}\"", output
  end
end