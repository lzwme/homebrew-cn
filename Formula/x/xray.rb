class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:xtls.github.io"
  url "https:github.comXTLSXray-corearchiverefstagsv25.2.21.tar.gz"
  sha256 "a565db518d2da12fabb74e123d9bf2bdbc34420b81373938f8fcbc7004fda3ba"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https:github.comXTLSXray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f05568d8c7e729a0576c40cf390b825b4e063a5869c6de259afc5e881bf82ab8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f05568d8c7e729a0576c40cf390b825b4e063a5869c6de259afc5e881bf82ab8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f05568d8c7e729a0576c40cf390b825b4e063a5869c6de259afc5e881bf82ab8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dc243d6ce6f0ef9cee009963290a7058d1d631e4c4e46a968f9bdcedcd7c0de"
    sha256 cellar: :any_skip_relocation, ventura:       "5dc243d6ce6f0ef9cee009963290a7058d1d631e4c4e46a968f9bdcedcd7c0de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "639b7925309b3372261110da57ff1c56216e8031b4e5dcc185acd9e1317eceef"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202501190004geoip.dat"
    sha256 "4f8d16184b6938e635519bc91cb978dcea6884878e39f592f7144135401d6bb6"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20250124154827dlc.dat"
    sha256 "ac12d81edc6058b3c66ae96a0a26ca8281616d96ea86d0d77b2ceff34a3e1a9d"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https:raw.githubusercontent.comv2flyv2ray-corev5.26.0releaseconfigconfig.json"
    sha256 "15a66415d72df4cd77fcd037121f36604db244dcfa7d45d82a0c33de065c6a87"

    livecheck do
      url "https:github.comv2flyv2ray-core.git"
    end
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
    assert_path_exists testpath"log"
  end
end