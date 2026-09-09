class Mktxp < Formula
  include Language::Python::Virtualenv

  desc "Prometheus Exporter for Mikrotik RouterOS devices"
  homepage "https://github.com/akpw/mktxp"
  url "https://files.pythonhosted.org/packages/73/27/8c7116d6ac06994bb5c2c47c27c691bd8de9d6ba66236daea5414a78dff5/mktxp-2.0.2.tar.gz"
  sha256 "36acee8909318d117ad4c123d0e8d183b57f1ce9b5deae0b384e1813266e2749"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e98a9a153e67700b369bb250785bb3a995954665d29c85bed912e3f82dfa8dc9"
    sha256 cellar: :any, arm64_sequoia: "722c9db42aae31bb08dc836ee418fe67b6628646532e136b28f18339cdb1266a"
    sha256 cellar: :any, arm64_sonoma:  "133e0922cd422b625d09cb403aa38303e7ee0fbbc4bf74df8124d177dd9d8ca5"
    sha256 cellar: :any, arm64_linux:   "6585afa77bcb754440c68494c9e55faf2b7ab2edc1f66c4ac7814c84480a9182"
    sha256 cellar: :any, x86_64_linux:  "45ab01e984c107913e68b157b6ccd1d246dc06717f405e4211d047141e233446"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/0a/ea/13a1ef3c12d12662905801495283530251918b70d62d368f1d2e0272c70d/humanize-4.16.0.tar.gz"
    sha256 "7dc2244a2f84a4bfb1d36c37bac80cd78e35cdc5c119206d87b018e1445f3a3f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/52/73/f1334c29c2af4cd9dba6c7817e61b611bd0215e2eb5565c6064a4de18802/prometheus_client-0.26.0.tar.gz"
    sha256 "04a91bcf94e2cf74a44a1a874d651a2e853ed354b6e822f3b7487751465d5c2b"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "routeros-api" do
    url "https://files.pythonhosted.org/packages/3b/3d/414cfbdc91ca6cf127cde120178ec0961caec4b1810e654f2d4520a475b7/routeros_api-0.21.0.tar.gz"
    sha256 "0d37452a4ff85cd476dca392068d7d76ba430c9b055c39d8dabc5930a997d82d"
  end

  resource "speedtest-cli" do
    url "https://files.pythonhosted.org/packages/85/d2/32c8a30768b788d319f94cde3a77e0ccc1812dca464ad8062d3c4d703e06/speedtest-cli-2.1.3.tar.gz"
    sha256 "5e2773233cedb5fa3d8120eb7f97bcc4974b5221b254d33ff16e2f1d413d90f0"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/1c/dc/0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2/texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  resource "waitress" do
    url "https://files.pythonhosted.org/packages/bf/cb/04ddb054f45faa306a230769e868c28b8065ea196891f09004ebace5b184/waitress-3.0.2.tar.gz"
    sha256 "682aaaf2af0c44ada4abfb70ded36393f0e307f4ab9456a215ce0020baefc31f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mktxp info")

    assert_match "Sample-Router", shell_output("#{bin}/mktxp --cfg-dir #{testpath} show")
  end
end