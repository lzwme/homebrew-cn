class EulerPy < Formula
  include Language::Python::Virtualenv

  desc "Project Euler command-line tool written in Python"
  homepage "https:github.comiKevinYEulerPy"
  url "https:files.pythonhosted.orgpackagesa641f074081bc036fbe2f066746e44020947ecf06ac53b6319a826023b8b5333EulerPy-1.4.0.tar.gz"
  sha256 "83b2175ee1d875e0f52b0d7bae1fb8500f5098ac6de5364a94bc540fb9408d23"
  license "MIT"
  revision 3
  head "https:github.comiKevinYEulerPy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c005ce9f3a3d171dd8a0a1fcdd333a50796f6ecd9c8d2388e826c17bfb06baf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c005ce9f3a3d171dd8a0a1fcdd333a50796f6ecd9c8d2388e826c17bfb06baf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c005ce9f3a3d171dd8a0a1fcdd333a50796f6ecd9c8d2388e826c17bfb06baf"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c5da5389a951513481ec408bc198369e971fda5759ced080b229d322ea31edb"
    sha256 cellar: :any_skip_relocation, ventura:        "7c5da5389a951513481ec408bc198369e971fda5759ced080b229d322ea31edb"
    sha256 cellar: :any_skip_relocation, monterey:       "5c005ce9f3a3d171dd8a0a1fcdd333a50796f6ecd9c8d2388e826c17bfb06baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47a547a457b0c89fc23a52eb1635b35703d07ae4a6d6d619eed5f45b9bd2aa2d"
  end

  depends_on "python@3.12"

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "open3"
    output = Open3.capture2("#{bin}euler", stdin_data: "\n")
    # output[0] is the stdout text, output[1] is the exit code
    assert_match 'Successfully created "001.py".', output[0]
    assert_equal 0, output[1]
    assert_predicate testpath"001.py", :exist?
  end
end