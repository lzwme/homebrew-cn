class Pyvim < Formula
  include Language::Python::Virtualenv

  desc "Pure Python Vim clone"
  homepage "https:github.comprompt-toolkitpyvim"
  url "https:files.pythonhosted.orgpackagesc33104e144ec3a3a0303e3ef1ef9c6c1ec8a3b5ba9e88b98d21442d9152783c1pyvim-3.0.3.tar.gz"
  sha256 "2a3506690f73a79dd02cdc45f872d3edf20a214d4c3666d12459e2ce5b644baa"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e4c9ae743c25b11c373055da09e5741f8978457575847589d44a9916b788f3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1da6f44b9955463f99b8c04b606fddd3697e6036db65c17800b65526c93224e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3384b88b9d1b9cc66426343366f07fadae5202397727c3e694bd62bc942bbe1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b940a3731430d50ba62cd35d111d1a7ef316bc8268c4452c21b8f641d10584a"
    sha256 cellar: :any_skip_relocation, ventura:        "fa3f1f6b006a2296b3a20a4bfdd1547fc59a45893a0c75a9b272fcabab5c9ddd"
    sha256 cellar: :any_skip_relocation, monterey:       "8012317bf225ae6cee1e2d882c367de498023915b0275e4a7bfdd0c486c153b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcede15ebeb6ab14f705aafa482ee208beea862817095707daaf1205dedb2548"
  end

  depends_on "pygments"
  depends_on "python@3.12"
  depends_on "six"

  resource "docopt" do
    url "https:files.pythonhosted.orgpackagesa2558f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages9a0276cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2baprompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "pyflakes" do
    url "https:files.pythonhosted.orgpackages8bfb7251eaec19a055ec6aafb3d1395db7622348130d1b9b763f78567b2aab32pyflakes-3.1.0.tar.gz"
    sha256 "a0aae034c444db0071aa077972ba4768d40c830d9539fd45bf4cd3f8f6992efc"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackagescbee20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04bawcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Need a pty due to https:github.comprompt-toolkitpyvimissues101
    require "pty"
    PTY.spawn(bin"pyvim", "--help") do |r, _w, _pid|
      assert_match "Vim clone", r.read
    end
  end
end