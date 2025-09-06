class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://ghfast.top/https://github.com/XTLS/Xray-core/archive/refs/tags/v25.9.5.tar.gz"
  sha256 "5c215908982635cc507629e1d366f72a3bf42f1237bcab6687c7a1e8f757bc0d"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bda4ec0fe447d4e3bebf6b8771ee23913cd3f79abf25c7f6c3194f98d9f486f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bda4ec0fe447d4e3bebf6b8771ee23913cd3f79abf25c7f6c3194f98d9f486f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bda4ec0fe447d4e3bebf6b8771ee23913cd3f79abf25c7f6c3194f98d9f486f"
    sha256 cellar: :any_skip_relocation, sonoma:        "39f46e05a0c677ab79a132b5ffa14b7adfa2c0cd6d872238bc5f830b4714562b"
    sha256 cellar: :any_skip_relocation, ventura:       "39f46e05a0c677ab79a132b5ffa14b7adfa2c0cd6d872238bc5f830b4714562b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e907fc33367fcc0535e18af33835b0fd0c8c112db31e7e70d52fa2b3d16fee3e"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202509050142/geoip.dat"
    sha256 "a01e09150b456cb2f3819d29d6e6c34572420aaee3ff9ef23977c4e9596c20ec"
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