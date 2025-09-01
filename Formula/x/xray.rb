class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://ghfast.top/https://github.com/XTLS/Xray-core/archive/refs/tags/v25.8.31.tar.gz"
  sha256 "69f2586627b95c772cc640850db5786def538c547dc5fa22f7fa8025bae302d2"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9baa6df15e197d196d120de968ca134f7e14a6c554c77be1c8d570954083afa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9baa6df15e197d196d120de968ca134f7e14a6c554c77be1c8d570954083afa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9baa6df15e197d196d120de968ca134f7e14a6c554c77be1c8d570954083afa4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f579adb2c69da4fc9ef398ec463b5d2efc9073747c6b2de3d572c7cfb1409629"
    sha256 cellar: :any_skip_relocation, ventura:       "f579adb2c69da4fc9ef398ec463b5d2efc9073747c6b2de3d572c7cfb1409629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bdf6adc82f961760ea67ede3b04f8662f4d19c6f8da88d507ca1fa67d91a79a"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202508140022/geoip.dat"
    sha256 "54761d8691a5756fdb08d2cd4d0a9c889dbaab786e1cf758592e09fb00377f53"
  end

  resource "geosite" do
    url "https://ghfast.top/https://github.com/v2fly/domain-list-community/releases/download/20250829121920/dlc.dat"
    sha256 "186158b6c2f67ac59e184ed997ebebcef31938be9874eb8a7d5e3854187f4e8d"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://ghfast.top/https://raw.githubusercontent.com/v2fly/v2ray-core/v5.38.0/release/config/config.json"
    sha256 "15a66415d72df4cd77fcd037121f36604db244dcfa7d45d82a0c33de065c6a87"

    livecheck do
      url "https://github.com/v2fly/v2ray-core.git"
    end
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args(output: execpath, ldflags:), "./main"
    (bin/"xray").write_env_script execpath,
      XRAY_LOCATION_ASSET: "${XRAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgshare.install resource("geoip")
    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
    pkgetc.install resource("example_config")
  end

  def caveats
    <<~EOS
      An example config is installed to #{etc}/xray/config.json
    EOS
  end

  service do
    run [opt_bin/"xray", "run", "--config", "#{etc}/xray/config.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~JSON
      {
        "log": {
          "access": "#{testpath}/log"
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
    output = shell_output "#{bin}/xray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_path_exists testpath/"log"
  end
end