class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/8d/c6/0fb0cd9ba25d87d6cf1dd0986b890c024fff6575846129b109a47def70b8/svtplay_dl-4.181.tar.gz"
  sha256 "0ab7d60be1cbc6392077f3b9c48c43dccdbd761a68b4835167b4988b15bf4485"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "640db0e5f0b409de77c4d0a7075652eb5f487fd607507e80b7aea4f809cb2597"
    sha256 cellar: :any,                 arm64_sequoia: "12a820202cfe3f867a8a40ed2802e0817fecd21291f15518cbbce693f5510656"
    sha256 cellar: :any,                 arm64_sonoma:  "e6a832afd0231216b3088c3a94951c48c214b14135cd677033d9ec8dfa4642b4"
    sha256 cellar: :any,                 sonoma:        "63b3bf8ba7cf7b2f647f024d683c6d5910bd678df831c4bbe005c43ae768de83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e74d674a53680c7e466c1f6841cca24e1b6bc684eeb1233941198e027c4f5588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc1b222282e3d6ae89a95aa22e097a0ce2be8b4bf1657d10070c0c7de3e8d696"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
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
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To use post-processing:
        `brew install ffmpeg`.
    EOS
  end

  test do
    url = "https://tv.aftonbladet.se/video/357803"
    match = "https://amd-ab.akamaized.net/ab/vod/2023/07/64b249d222f325d618162f76/720_3500_pkg.m3u8"
    assert_match match, shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end