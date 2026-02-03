class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://ghfast.top/https://github.com/XTLS/Xray-core/archive/refs/tags/v26.2.2.tar.gz"
  sha256 "ac96aeef609cccca15a4e3db4426fcc62c65d1e6438b59ebb4234b4d94e5800f"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ee00e6fcb52ac43ee59d5550a88b7e40f18f27490360c2cf0cbe83ef8df3743"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ee00e6fcb52ac43ee59d5550a88b7e40f18f27490360c2cf0cbe83ef8df3743"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ee00e6fcb52ac43ee59d5550a88b7e40f18f27490360c2cf0cbe83ef8df3743"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a386bbaffa01c37f005d7706c61d074318a4c2b05db8e36ff80a7cd69d83d79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4685d712173343e9a5b55c412ae06cf3ba882e47db8946043d60818cd1e9c81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9400ccc7b42433240dc6919e3593c84442ee7bd7304dd56c6a51777534273035"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202601220433/geoip.dat"
    sha256 "ed2de9add79623e2e5dbc5930ee39cc7037a7c6e0ecd58ba528b6f73d61457b5"
  end

  resource "geosite" do
    url "https://ghfast.top/https://github.com/v2fly/domain-list-community/releases/download/20260201133610/dlc.dat"
    sha256 "1ee9a82122777fbe524ed3a105aa10f7887f5884ffccfe59fc26ccb65241b650"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://ghfast.top/https://raw.githubusercontent.com/v2fly/v2ray-core/v5.44.1/release/config/config.json"
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