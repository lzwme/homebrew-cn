class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:xtls.github.io"
  url "https:github.comXTLSXray-corearchiverefstagsv24.11.21.tar.gz"
  sha256 "e45ad1fa11457101776d2c0d7ed8ed7c669b714e7687a85830e44a6e4a52fe05"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https:github.comXTLSXray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dce319671d4825e835d765520c2351777c4fdc53242ac2b2e9cf64d32164c23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dce319671d4825e835d765520c2351777c4fdc53242ac2b2e9cf64d32164c23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8dce319671d4825e835d765520c2351777c4fdc53242ac2b2e9cf64d32164c23"
    sha256 cellar: :any_skip_relocation, sonoma:        "231f9dc085ad3395930804a105279b7132b80e84878ed77a7f0e5839e9466070"
    sha256 cellar: :any_skip_relocation, ventura:       "231f9dc085ad3395930804a105279b7132b80e84878ed77a7f0e5839e9466070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05b0b087542ff63ffa93c8eaf491b44e198e29ab66001c843ef940e67258196e"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202411210054geoip.dat"
    sha256 "eceaca175af7d0d368d42a23b7a2c7d73b98f033245dd0c42a72c2e622af4a11"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20241112092643dlc.dat"
    sha256 "f04433837b88a3f49d7cd6517c91e8f5de4e4496f3d88ef3b7c6be5bb63f4c6f"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https:raw.githubusercontent.comv2flyv2ray-corev5.19.0releaseconfigconfig.json"
    sha256 "15a66415d72df4cd77fcd037121f36604db244dcfa7d45d82a0c33de065c6a87"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexecname
    system "go", "build", *std_go_args(output: execpath, ldflags:), ".main"
    (bin"xray").write_env_script execpath,
      XRAY_LOCATION_ASSET: "${XRAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgshare.install resource("geoip")
    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
    pkgetc.install resource("example_config")
  end

  def caveats
    <<~EOS
      An example config is installed to #{etc}xrayconfig.json
    EOS
  end

  service do
    run [opt_bin"xray", "run", "--config", "#{etc}xrayconfig.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    (testpath"config.json").write <<~JSON
      {
        "log": {
          "access": "#{testpath}log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            },
            {
              "domains": [
                "geosite:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    JSON
    output = shell_output "#{bin}xray -c #{testpath}config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath"log", :exist?
  end
end