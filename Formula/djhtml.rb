class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/a4/1d/c051aceb436d47e176ad5e1af54f5e6c1ec5076dce19ae875c9f929d205a/djhtml-3.0.4.tar.gz"
  sha256 "f1342abc1a0cacaa7b0371fdbb482d2e67b1e1071f777f1f83f6571240666315"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c6c4d803da342bce24c0c6deafd8b3d8ae214cdc58e90d44e435f36b9291da1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "129d8fda609e4f6b8dda7c21fdfef163bfeb2e9875f0a86aa5fa2f339117c930"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d27c368885bf411839210961ad4371d46b8657a00dffa5b0b21eba09d5b0858e"
    sha256 cellar: :any_skip_relocation, ventura:        "4ac0bdfab8885fa701e21798d3f897e13b8adb42790b5d6113818e7c570d94c8"
    sha256 cellar: :any_skip_relocation, monterey:       "4c85aadf6ab2a29c0536385ec24921f563cc927b5ffe4f9bf3f5acba1907cd17"
    sha256 cellar: :any_skip_relocation, big_sur:        "09c8c85cd36f4d13af0b2fe132246cbcd01c918c5c3d5c014cbd66b5aa40d841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ba16d37e9ed0ffef07f988f2c91c75f1075c02e534d2acc554e81bdfe37bab0"
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