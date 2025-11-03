class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/b5/f0/170b552d5cbcf758bfaf2bfd33c189fd0212ece6c3c019947d685025773e/svtplay_dl-4.157.tar.gz"
  sha256 "34e22a61b39467b38e6bb0bedaddfcea17e53832b0df0b3b2ab082968847b3c2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7289bccb785a957af94888fd1754f4ff209b7f6f2081ccbc8c927390136a2868"
    sha256 cellar: :any,                 arm64_sequoia: "e204b6d629f449d6bb0a5a415dd3c230aa6b5d1f7e79c789a208a4d008a5b3d6"
    sha256 cellar: :any,                 arm64_sonoma:  "c3b4370abae2fc4b24bd820dcd2b91649b689ce687b47d7b1b4c477bf81b13b4"
    sha256 cellar: :any,                 sonoma:        "725e2b80511ee1a54165c2b9622151ea21f7f954051b5bc15a08a39a3ce840e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6c1ed2351978e00dd3027b60dbb0a76acb17d3c24f6e8bfd747b11bfaa58358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7484e7d46aaedde526dc496387422d0d8a964bdd632cd30b4c209305c7a8174c"
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
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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