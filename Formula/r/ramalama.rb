class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https:github.comcontainersramalama"
  url "https:files.pythonhosted.orgpackages7793835359deb26ff88efab14b535bb0bd8d2ffaf903238b588fa810a8b40bc1ramalama-0.6.0.tar.gz"
  sha256 "23b42864952604f1f7666412fb3d296738fd3369287c97f340066be90a4a2235"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3d279edcd13a35a3baca8cdd379489e2cd904c80a711127a542cb825321f7de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3d279edcd13a35a3baca8cdd379489e2cd904c80a711127a542cb825321f7de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3d279edcd13a35a3baca8cdd379489e2cd904c80a711127a542cb825321f7de"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c0671e2235197b4f71658f630d0af7c5c47cea307c56a0d417841bcb1cabe6a"
    sha256 cellar: :any_skip_relocation, ventura:       "5c0671e2235197b4f71658f630d0af7c5c47cea307c56a0d417841bcb1cabe6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a06eed5683e2f16ad5a80450f65547134740eea5d17031addb97a972997bce7f"
  end

  depends_on "python@3.13"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages0cbe6c23d80cb966fb8f83fb1ebfb988351ae6b0554d0c3a613ee4531c026597argcomplete-3.5.3.tar.gz"
    sha256 "c12bf50eded8aebb298c7b7da7a5ff3ee24dffd9f5281867dfe1424b58c55392"
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