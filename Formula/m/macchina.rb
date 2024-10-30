class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https:github.comMacchina-CLImacchina"
  url "https:github.comMacchina-CLImacchinaarchiverefstagsv6.3.1.tar.gz"
  sha256 "385bccc02f67c9ed6b9a483dbebdec901eb4beb82b15bb7969ee36028c19e475"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ecc57084ae105e0d8068e693cb2b8d8ad97fdf67333fc0b56cb247492bb89dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "401d23f452588558b961d447ba3b55c299ca65748b5e91640868ee48437fd2d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "668fd39b49bb00d25713ecbd78fa7d72b48cb6b4eaa7c90aecfb1598d586a7ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "a77aaa3528f6318829f13cd4105bc61efcf56dab104500d9312c0ea57dd36197"
    sha256 cellar: :any_skip_relocation, ventura:       "4835dc98c9415fdabbf407a14529b2d84cf4b2be4b1412cdbcc47d7e089a50b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4470df67ea312015e1c176847f29fba03c193af0441683a2cec0005313d3594"
  end

  depends_on "rust" => :build

  # In order to update the dependent resources, check the link below
  # https:github.comMacchina-CLImacchinatreemainvendor
  # and find commit ids for the submodules, download tarball and update checksum.
  resource "ansi-to-tui" do
    url "https:github.comMacchina-CLIansi-to-tuiarchive950d68067ed8c7f74469eb2fd996e04e1b931481.tar.gz"
    sha256 "e5f7b361dbc8400355ae637c4b66bcc28964e31bf634d6aa38684c510b38460e"
  end

  resource "color-to-tui" do
    url "https:github.comMacchina-CLIcolor-to-tuiarchive9a1b684d92cc64994889e100575e38316a68670b.tar.gz"
    sha256 "c30ec8f9314afd401c86c7b920864a6974557e72ad21059d3420db2dcffd02cb"
  end

  def install
    (buildpath"vendoransi-to-tui").install resource("ansi-to-tui")
    (buildpath"vendorcolor-to-tui").install resource("color-to-tui")

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "We've collected a total of 19 readouts", shell_output("#{bin}macchina --doctor")
  end
end