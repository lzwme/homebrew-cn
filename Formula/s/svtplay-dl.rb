class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/81/70/a52d90b1d7ec2b9bf4e50c7e0d705ce1783beefad98e3b8202c5a68b9b06/svtplay_dl-4.149.tar.gz"
  sha256 "3e3748be3b07e7e00366c71804167ae45be4d3de54ba2222350c8e2ace4f04af"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c0cb4bf65e3d62a663365f98f7746839658f823e6218351507ec5bb47d240226"
    sha256 cellar: :any,                 arm64_sequoia: "aac7d50ec9d592d619ec674bd27d523080132204251e392abffd3e721ea6c48e"
    sha256 cellar: :any,                 arm64_sonoma:  "0f84be6d3ee7bb6af169039a9e1ddf78900682f2f7cc9ecc235c521136fe6dda"
    sha256 cellar: :any,                 sonoma:        "41720c871ffec413f7bb1e876c2c5df1c49b4f4a0e6d35ba299b8d92770d2735"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b866013cc624905e9305500194ddc697e0d0cf627cd9a742f6b7e7696a27fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "818fcbf99bbc13bdd7401bb7fdbe5b9bdfcfcbfbe025147afc9f2b44604dbc5f"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.14"

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