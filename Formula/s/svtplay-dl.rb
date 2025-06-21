class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/90/dd/c20e5a5bed00ec886ff9bb6a3ff778c807dbe2dad17776ee4ad11040ed40/svtplay_dl-4.113.tar.gz"
  sha256 "953581c6c1d272a5c559d2662ed13d0547910eb9878d4c839a7505e4fbe1ffb4"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "824ee79542471fd15d849f50f6828331c853229b109108a5551d0c263cb798c2"
    sha256 cellar: :any,                 arm64_sonoma:  "f288ab5c1b50145a28c8e40293f3e57358328b524878c29d4ef2a1fd8327cdfe"
    sha256 cellar: :any,                 arm64_ventura: "3b7128941b7ffd4293d81c1cdee4ffceafd0a8586615918de7a8f83bcd68a6eb"
    sha256 cellar: :any,                 sonoma:        "b1795ee0221ae733b7f3cc505957e60c5c62d4d9e76469c99c74d89d5088d970"
    sha256 cellar: :any,                 ventura:       "1d173558c306a11c7363a86f26d5dafe00f147478ef5dc286512345fb595dc4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a74549ed69e1cd07b4205b1b47477b96ee92615ad94d38dfc4d005fb0abd8785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eadfb6dbcf0c906310afe348fcb8fb11855c0f33c1029ac7acd542d89830eab5"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
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