class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://ghfast.top/https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.46.0.tar.gz"
  sha256 "ae4e85dfe0efa299e9cc4097aa2ea077f409237797e6b51093f986ad8fbe603a"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4365ca9f23219aca446bc5eab20715fa609427f30983952e0feea3dee5bf2359"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4365ca9f23219aca446bc5eab20715fa609427f30983952e0feea3dee5bf2359"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4365ca9f23219aca446bc5eab20715fa609427f30983952e0feea3dee5bf2359"
    sha256 cellar: :any_skip_relocation, sonoma:        "54130b49b20ddff21c6579e83d998e793fe4b359aadbe6f17323b11b48ea9409"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4544b3e23015a64edf27ad01102c4238898050d323ff8b0c96d5b563db5d57f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74caf913915f9dbe77745bab709f5a711b95aea4ec324e73a2dd236f000f2fa8"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202603050223/geoip.dat"
    sha256 "c6c1d1be0d28defef55b153e87cb430f94fb480c8f523bf901c5e4ca18d58a00"
  end

  resource "geoip-only-cn-private" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202603050223/geoip-only-cn-private.dat"
    sha256 "55cef17909fd51a3381a034c72635e2512121495b0443fc10aed7521fecce55a"
  end

  resource "geosite" do
    url "https://ghfast.top/https://github.com/v2fly/domain-list-community/releases/download/20260309055128/dlc.dat"
    sha256 "3ec0ebbc2776133afe1e81c565e834e692e25d103104d2950b5e94328f1d8e11"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags:, output: libexec/"v2ray"), "./main"

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
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_path_exists testpath/"log"
  end
end