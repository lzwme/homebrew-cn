class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/a5/2c/0e31b3ff89e499a02b3b48b886d489f3838cce0d0e237f024d6f0105d213/svtplay_dl-4.167.tar.gz"
  sha256 "55cf66826547c960c422985304414894e0b7795457d1ed6eca78c8bd788d50c4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cda7c8e4c03e5a5ff3c12c63163a0fd565c0199c0b892e0c16f54781b5d95087"
    sha256 cellar: :any,                 arm64_sequoia: "67865b040972beb0cd4fb5e9b468dfcda049c4843a267a5c8d5292d0e18db2b4"
    sha256 cellar: :any,                 arm64_sonoma:  "d6b88986faf3bfa306f97e6605fe7eb44dc5aaf1500073251b9c53a8f8d4d9b6"
    sha256 cellar: :any,                 sonoma:        "32a2bf647eb31ad490ecb9d53107df9056b77e6fb4d96f0e794520dd904f47e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9870555d7c9ea90390aa1d74295b51d5cb37a6202aeb9d458d8e46847d102587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f139b1180a9106cb38b33049d6a7ea0194b8c7ccd6befa6d8f49dc92fbd266d"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1e/24/a2a2ed9addd907787d7aa0355ba36a6cadf1768b934c652ea78acbd59dcd/urllib3-2.6.2.tar.gz"
    sha256 "016f9c98bb7e98085cb2b4b17b87d2c702975664e4f060c6532e64d1c1a5e797"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To use post-processing options:
        `brew install ffmpeg` or `brew install libav`.
    EOS
  end

  test do
    url = "https://tv.aftonbladet.se/video/357803"
    match = "https://amd-ab.akamaized.net/ab/vod/2023/07/64b249d222f325d618162f76/720_3500_pkg.m3u8"
    assert_match match, shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end