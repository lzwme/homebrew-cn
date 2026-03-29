class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://ghfast.top/https://github.com/XTLS/Xray-core/archive/refs/tags/v26.3.27.tar.gz"
  sha256 "992a4997e6bb846d11469435d687f99ef812fcde1e0a009bb8e95189ea20331d"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bff981876814bff60240beb45a257ddaea1fe1b6852ec345b52d2701933245a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bff981876814bff60240beb45a257ddaea1fe1b6852ec345b52d2701933245a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bff981876814bff60240beb45a257ddaea1fe1b6852ec345b52d2701933245a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd67caebe5bb10ff6e511bad9ff4ff733f3b55bcd5baf60bb64b64cd3839929c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6d56ea0b24d8b7eb17ad076a02ffdffa92a41598fd14f08d20fc0eed0219192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb09e38ca9e9c9f1d8436bb76628ad708198bab80fa0f159949b3aa32100de46"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202601220433/geoip.dat"
    sha256 "ed2de9add79623e2e5dbc5930ee39cc7037a7c6e0ecd58ba528b6f73d61457b5"
  end

  resource "geosite" do
    url "https://ghfast.top/https://github.com/v2fly/domain-list-community/releases/download/20260203145437/dlc.dat"
    sha256 "158e0e3052238dcdd09d58857032c67da49b933b3a9fd74fedf2c684e21d4f87"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://ghfast.top/https://raw.githubusercontent.com/v2fly/v2ray-core/v5.48.0/release/config/config.json"
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