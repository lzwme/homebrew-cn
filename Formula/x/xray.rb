class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://ghfast.top/https://github.com/XTLS/Xray-core/archive/refs/tags/v25.12.2.tar.gz"
  sha256 "e39c40b85decddea0b59719dae33df26aa149ac6fc673e7db9266e731cc2b3ad"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c55c904949260b68fdf7fa9046267017e33acb3fe34a1d4aca5c567ffe8027a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c55c904949260b68fdf7fa9046267017e33acb3fe34a1d4aca5c567ffe8027a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c55c904949260b68fdf7fa9046267017e33acb3fe34a1d4aca5c567ffe8027a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "77226698858f25d7305f2512558e41b8c68d51441439b2d5f68bfb43ebe83a5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43718cb3a6e551556a60ae22eee1ab19a8739c3cd5a8146d37814e8b425aa185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c514e156c240de3aa0274aa5f5c7815a024758ff761f7e9890dcb4ecec92ac58"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202511210201/geoip.dat"
    sha256 "2445b44d9ae3ab9a867c9d1e0e244646c4c378622e14b9afaf3658ecf46a40b9"
  end

  resource "geosite" do
    url "https://ghfast.top/https://github.com/v2fly/domain-list-community/releases/download/20251202060244/dlc.dat"
    sha256 "b925be67555a8b31a713759aa999babb674dcce5f803e67ab5b726efad2e8e92"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://ghfast.top/https://raw.githubusercontent.com/v2fly/v2ray-core/v5.41.0/release/config/config.json"
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