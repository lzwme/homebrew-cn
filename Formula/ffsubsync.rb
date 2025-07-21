class Ffsubsync < Formula
  include Language::Python::Virtualenv

  desc "Automagically synchronize subtitles with video"
  homepage "https://github.com/smacke/ffsubsync"
  url "https://files.pythonhosted.org/packages/f8/9a/6a08de2f53caa79d9157ef8bd7cc18b36ef82d0b0b59e4e2a16e627b9eb1/ffsubsync-0.4.29.tar.gz"
  sha256 "ca0d641e6dd20e6ac5a1d622f5877b0b9c2a489034de822ff168fd5af29edcd6"
  license "MIT"
  head "https://github.com/smacke/ffsubsync.git", branch: "main"

  depends_on "python@3.12"

  resource "auditok" do
    url "https://files.pythonhosted.org/packages/7a/10/36727094aeb828ad4d9bc70e9c5bb422b1abf64d2b5fe8ad305ce337522b/auditok-0.1.5.tar.gz"
    sha256 "1cdb30f552cfed7120b3c1365faa7bca00cce3b0305b13188e9b62a649c58a0e"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "faust-cchardet" do
    url "https://files.pythonhosted.org/packages/e9/53/2125d17d7c2a14b76303bf5c3c5db35ea8e4b8a14817bb191c601d67e288/faust-cchardet-2.1.19.tar.gz"
    sha256 "f89386297cde0c8e0f5e21464bc2d6d0e4a4fc1b1d77cdb238ca24d740d872e0"
  end

  resource "ffmpeg-python" do
    url "https://files.pythonhosted.org/packages/dd/5e/d5f9105d59c1325759d838af4e973695081fbbc97182baf73afc78dec266/ffmpeg-python-0.2.0.tar.gz"
    sha256 "65225db34627c578ef0e11c8b1eb528bb35e024752f6f10b78c011f6f64c4127"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/2e/19/d7c972dfe90a353dbd3efbbe1d14a5951de80c99c9dc1b93cd998d51dc0f/numpy-2.3.1.tar.gz"
    sha256 "1ec9ae20a4226da374362cca3c62cd753faf2f951440b0e3b98e93c235441d2b"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pysubs2" do
    url "https://files.pythonhosted.org/packages/31/4a/becf78d9d3df56e6c4a9c50b83794e5436b6c5ab6dd8a3f934e94c89338c/pysubs2-1.8.0.tar.gz"
    sha256 "3397bb58a4a15b1325ba2ae3fd4d7c214e2c0ddb9f33190d6280d783bb433b20"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a1/53/830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8/rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "srt" do
    url "https://files.pythonhosted.org/packages/66/b7/4a1bc231e0681ebf339337b0cd05b91dc6a0d701fa852bb812e244b7a030/srt-3.5.3.tar.gz"
    sha256 "4884315043a4f0740fd1f878ed6caa376ac06d70e135f306a6dc44632eed0cc0"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/98/5a/da40306b885cc8c09109dc2e1abd358d5684b1425678151cdaed4731c822/typing_extensions-4.14.1.tar.gz"
    sha256 "38b39f4aeeab64884ce9f74c94263ef78f3c22467c8724005483154c26648d36"
  end

  resource "webrtcvad" do
    url "https://files.pythonhosted.org/packages/89/34/e2de2d97f3288512b9ea56f92e7452f8207eb5a0096500badf9dfd48f5e6/webrtcvad-2.0.10.tar.gz"
    sha256 "f1bed2fb25b63fb7b1a55d64090c993c9c9167b28485ae0bcdd81cf6ede96aea"
  end

  def install
    inreplace "setup.py" do |s|
      s.gsub!(/^requirements =.*/, "requirements = []")
    end
    virtualenv_install_with_resources
  end
end