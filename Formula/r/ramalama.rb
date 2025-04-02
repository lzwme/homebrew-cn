class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https:github.comcontainersramalama"
  url "https:files.pythonhosted.orgpackagesad3a3fc40ae9331a09a1febdf0075eca328e46ba28b0431a44f11e10ae682eaeramalama-0.7.2.tar.gz"
  sha256 "4f77df954d34f96f38adf6ab0a90a06c7903085ba57609d48978ca1cce252579"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e96223443b42de99e1794de0428979bd38a0b308b82738e8494a30a4d662dc67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e96223443b42de99e1794de0428979bd38a0b308b82738e8494a30a4d662dc67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e96223443b42de99e1794de0428979bd38a0b308b82738e8494a30a4d662dc67"
    sha256 cellar: :any_skip_relocation, sonoma:        "26904f9bedb8b54e5e69ec20c2d481e454a4f046d2fe63ee474494563477ee20"
    sha256 cellar: :any_skip_relocation, ventura:       "26904f9bedb8b54e5e69ec20c2d481e454a4f046d2fe63ee474494563477ee20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6726ef5a6714d90d0ef2c120b6738dae4e98a47c5d5ba1f4f43bbb0bda9551c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6726ef5a6714d90d0ef2c120b6738dae4e98a47c5d5ba1f4f43bbb0bda9551c0"
  end

  depends_on "python@3.13"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages0a35aacd2207c79d95e4ace44292feedff8fccfd8b48135f42d84893c24cc39bargcomplete-3.6.1.tar.gz"
    sha256 "927531c2fbaa004979f18c2316f6ffadcfc5cc2de15ae2624dfe65deaf60e14f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "invalidllm was not found", shell_output("#{bin}ramalama run invalidllm 2>&1", 1)

    system bin"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}ramalama version")
  end
end