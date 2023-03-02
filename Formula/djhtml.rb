class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/b6/0f/5be9e91f5e9d1c9b46831987cb0087ad760827b239359c8d1e33174183e5/djhtml-3.0.2.tar.gz"
  sha256 "f260cdfe7033b21ebc01961db7e1c8832fd5830ec9af1b0e57f3e1f58deb1bd0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04faeb1da5b17a16bcc5a707236b93285c225dcf2779428c4aee84dcef6eca7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8478b30ef745876f32be53ebf93320ffd79c555bdb97a11c6d6b23c3acd183da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3eb977a27efb89abf0d1940ff37b98d456d2a0ec2a56df09b02c6ab419fc9a4"
    sha256 cellar: :any_skip_relocation, ventura:        "2267f0deabd8580c8f4f3e297b865d93451d47b9a74fbe8f469bba7b70a2e2b2"
    sha256 cellar: :any_skip_relocation, monterey:       "ff48f6bbd7352cef4112d6e70617e2306964277541b87c751338577e26a2b868"
    sha256 cellar: :any_skip_relocation, big_sur:        "5efd376bcb18d6973cf020cd35b0c986ea84889935bd9a1d3c9b39b3f209b1cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4c197c330de5ae1629f5b817b761308db290df4284afb590f16264a666812b7"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.html"
    test_file.write <<~EOF
      <html>
      <p>Hello, World!</p>
      </html>
    EOF

    expected_output = <<~EOF
      <html>
        <p>Hello, World!</p>
      </html>
    EOF

    system bin/"djhtml", "--tabwidth", "2", test_file
    assert_equal expected_output, test_file.read
  end
end