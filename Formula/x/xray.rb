class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://ghfast.top/https://github.com/XTLS/Xray-core/archive/refs/tags/v26.10.21.tar.gz"
  sha256 "44ef4874529a03848c90f1fdcfb763350fbc5f1de741ec90e0024d651df25650"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab92f7076c6ccb14f1d5c313f265f4dcf91650a17e3eeebac90e0644ace8616b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab92f7076c6ccb14f1d5c313f265f4dcf91650a17e3eeebac90e0644ace8616b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab92f7076c6ccb14f1d5c313f265f4dcf91650a17e3eeebac90e0644ace8616b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c7effe6a9d5a8885b2a1880b3515e68d33578246471adc4f74a34891ac7e1153"
    sha256 cellar: :any,                 x86_64_linux:      "3c42f1af15bd85199da217f44861b4b080349791f438fb933a858e16c91d4bfa"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghfast.top/https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202610212206/geoip.dat"
    sha256 "4a1b1eddabf5614fa51dd93ac0498856cb82dd65933cd6d6d5890d8c7bb5e902"
  end

  resource "geosite" do
    url "https://ghfast.top/https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202610212206/geosite.dat"
    sha256 "77cc7cc99d8a6f606a8c266308501e26fd7038b9c0508db0e551b933c41cdedf"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://ghfast.top/https://raw.githubusercontent.com/v2fly/v2ray-core/v5.55.0/release/config/config.json"
    sha256 "15a66415d72df4cd77fcd037121f36604db244dcfa7d45d82a0c33de065c6a87"

    livecheck do
      url "https://github.com/v2fly/v2ray-core.git"
    end
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    execpath = libexec/name
    system "go", "build", *std_go_args(output: execpath, ldflags: "-buildid="), "./main"
    (bin/"xray").write_env_script execpath,
      XRAY_LOCATION_ASSET: "${XRAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgshare.install resource("geoip")
    resource("geosite").stage do
      pkgshare.install "geosite.dat"
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