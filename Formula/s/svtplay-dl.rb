class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/98/c1/4042e9ea5c4cb096be4b3ee2f8c8241e8b0c463a59261af7ceab227cccd3/svtplay_dl-4.131.tar.gz"
  sha256 "f472a9fc24ea835d9d1b59744b57baefa111b610afed49e4f3e14f71bc33e50d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "01050831c5cb2e6d3cacd09df1d2dfc61a58264b4663af77de6b7091ff9c60fa"
    sha256 cellar: :any,                 arm64_sonoma:  "d8472f71e376d85a61048c0e92354c5025bbbad0d9645a5e01703e770bf58f0b"
    sha256 cellar: :any,                 arm64_ventura: "637b9d990386fb17243d18ed48d678bc8d6f1029f357550dd78f23cea5b586e7"
    sha256 cellar: :any,                 sonoma:        "b28d837f0e29f7e58c541f2d5783afea8649aa24118634b13f6b171e84b7b66a"
    sha256 cellar: :any,                 ventura:       "703521b4802bd1eb0cdbfa4071123cae91d861ee0cfe8453adab197bb4bece13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d18a2320a39f8fd11eb57664e2756b79be8288f508804e804a7879896f776813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e469ff93b95d31ae53a51434e89b0aacd74b7fa86258764d320f98e025950f1"
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