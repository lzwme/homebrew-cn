class Mktxp < Formula
  include Language::Python::Virtualenv

  desc "Prometheus Exporter for Mikrotik RouterOS devices"
  homepage "https://github.com/akpw/mktxp"
  url "https://files.pythonhosted.org/packages/51/38/8d05e5536f574fd39da0e61833dae05488ac928ed2d6bcca4b12f6a9f364/mktxp-2.0.0.tar.gz"
  sha256 "53608c43f8e56298005fabe9d1e4658627ad2ca7a87073d6e4bcb57b9d42d97a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "73b0e3dd30fdb7449fe8705fc2081548e4d264b98b9babf32b13b317bce93e89"
    sha256 cellar: :any, arm64_sequoia: "b054bd1fdb5478c6440ec3c59c289a2076cc277f635169cdb5cd1cfd48ab8e40"
    sha256 cellar: :any, arm64_sonoma:  "53285d8ac5ea1c751ccb02d57241164d69031f3fcf02083ffa58dce909664f69"
    sha256 cellar: :any, arm64_linux:   "c4611c7555505fc6d1282bdcbb4a362a8fdf4cc6c691d057c2c204e95603b81f"
    sha256 cellar: :any, x86_64_linux:  "6af104e79ef7f1a293bc5da22eef63e8b785d99447c1d06fbd2d81947d2a9cc4"
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