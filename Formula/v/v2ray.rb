class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://ghproxy.com/https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.9.0.tar.gz"
  sha256 "8373b3cf066e870a7eecd61f0e2c63083cc3f36713ec4d22170801eae180a2e7"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f569f70d2785275498aee88fe7d0596c1a7fdc7ec8d251ca7155182f4a9d78d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4feb6b42f1ae8b9595a70818b5fc7a8c3c6dfb8c64c89636964f8db336afa211"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd5d976169841710ece241f7a8099737cdc962b8572119a5950a7b00516ab3b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "216b41988d13339a8e964374ecc3a6945a5df133a403aec54111e8b0ec096e69"
    sha256 cellar: :any_skip_relocation, ventura:        "85fc0bb0f4e0a4171437237b5d9b8082d9c20b7e49298e83151b1b3309add0cc"
    sha256 cellar: :any_skip_relocation, monterey:       "41cea40a32dbff8fb7835c2bbc3126baf8ba74e4d068ff0b253e68ffe04e964d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54aaac754e64687ba1f8309497cf0bdb0aa4bb18a6c31080cc28d4a30f5dd7df"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghproxy.com/https://github.com/v2fly/geoip/releases/download/202310190037/geoip.dat"
    sha256 "bc989d73a81be233e57b7bb4d6aed2b8e60f8d3e33f76cb78b89e14b67d12725"
  end

  resource "geoip-only-cn-private" do
    url "https://ghproxy.com/https://github.com/v2fly/geoip/releases/download/202310190037/geoip-only-cn-private.dat"
    sha256 "16889c54d791e4f77e439d738c3a31b599de985e514a23a4ebc7f68f10fd2358"
  end

  resource "geosite" do
    url "https://ghproxy.com/https://github.com/v2fly/domain-list-community/releases/download/20231025154305/dlc.dat"
    sha256 "26804c9b935f23d52875c15bdb47628b88b2a254eeb773fb5daa337e835af194"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags: ldflags, output: libexec/"v2ray"), "./main"

    (bin/"v2ray").write_env_script libexec/"v2ray",
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [opt_bin/"v2ray", "run", "-config", etc/"v2ray/config.json"]
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~EOS
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
    EOS
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end