class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/60/05/b1fa90ca956eac356aec82dddcc967b888201b05f9ff6205021108e5851e/fonttools-4.39.0.zip"
  sha256 "909c104558835eac27faeb56be5a4c32694192dca123d073bf746ce9254054af"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d326bf96e12680b77283788fb75d14c43932c5126528e5a9603163a4698d9b20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf343a18814a5aff945c4ae87efa68aa741ca6314def97d5d916246603f63cd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "311af8f7ef55d8ca7b5ba978c8a92fc7d93e0020f35448fb72aa7421a7c4f140"
    sha256 cellar: :any_skip_relocation, ventura:        "c41e5682cca6a2f58ebee76e83fbb324b81bd482c10da6058c8b0ff4ddb514d0"
    sha256 cellar: :any_skip_relocation, monterey:       "e8f8a65352062f973d4583a795dbde59e7faaaf3a759c85d2085f9cfe5bc1b9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecfa3e9411cff33e1d51eb4807232c3c28f11159eeeee97794d977432ff68e6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "557c5b970ce3e9a12dbcb788370431dd24e67de4042d3fb653700bb665bde2db"
  end

  depends_on "python@3.11"

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end