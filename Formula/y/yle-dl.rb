class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/a1/92/f2c10d7390899c9f26e08102143d9c0a8d375a7d7a7314e17913ddfa162e/yle_dl-20250730.tar.gz"
  sha256 "2122741f515d5829eff28b2f6b96c251f4f7434412ea6c3ca60e526e60563c89"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8002212d9df652c6b26e638a2dea16ddc2fd4b3a39eb02fb28a3495fb0095a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fd4a476b2f25a2a2512d8e0e0e59d92b30c36b69746f75dd4de517ec545732c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c98da4f9be2cf63ab996232f845c0e75b514ebd1a4d6a3d572b8b6a709669e12"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae813eefe91ebc5039a9b70e4e95ec2196afde071658caa52d70208e85cc86ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb10c6d6615807fc30118204a4ead746b701429349fd11bea31beafde1407a32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ef3c6ad29cbf06442042c266d5f68422abcefcee5764917154b92795a763328"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "python@3.14"
  depends_on "rtmpdump"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/85/4d/6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5d/configargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1c/43/554c2569b62f49350597348fc3ac70f786e3c32e7f19d266e19817812dd3/urllib3-2.6.0.tar.gz"
    sha256 "cb9bcef5a4b345d5da5d145dc3e30834f58e8018828cbc724d30b4cb7d4d49f1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
    assert_match "Traileri:", output
    assert_match "2012-05-30T10:51", output
  end
end