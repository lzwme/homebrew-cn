class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://ghfast.top/https://github.com/XTLS/Xray-core/archive/refs/tags/v25.8.3.tar.gz"
  sha256 "a7d3785fdd46f1b045b1ef49a2a06e595c327f514b5ee8cd2ae7895813970b2c"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "841277e2bcde24752b5cd836a1e9a8c54d864035ab06fd9193cd5ff2e1d1217c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "841277e2bcde24752b5cd836a1e9a8c54d864035ab06fd9193cd5ff2e1d1217c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "841277e2bcde24752b5cd836a1e9a8c54d864035ab06fd9193cd5ff2e1d1217c"
    sha256 cellar: :any_skip_relocation, sonoma:        "24c73b787b97c47585b2e4286a14996d05f6cdfab6a3efc6a2cc0152399cd39a"
    sha256 cellar: :any_skip_relocation, ventura:       "24c73b787b97c47585b2e4286a14996d05f6cdfab6a3efc6a2cc0152399cd39a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c090917e84eefc6dd3e10af4db69f92b8c56adaac4814ad34286d2caa409839"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202507050144/geoip.dat"
    sha256 "d77289a7465b6e59df39a2d46bd02b30b4fa7dd70939c13d431fd2bd8f448e10"
  end

  resource "geosite" do
    url "https://ghfast.top/https://github.com/v2fly/domain-list-community/releases/download/20250627153051/dlc.dat"
    sha256 "01dae2a9c31b5c74ba7e54d8d51e0060688ed22da493eaf09f6eeeec89db395e"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://ghfast.top/https://raw.githubusercontent.com/v2fly/v2ray-core/v5.37.0/release/config/config.json"
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