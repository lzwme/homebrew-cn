class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://ghfast.top/https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.35.0.tar.gz"
  sha256 "caf1e4a8bbed61748ae21c88bf6d158a9921513b8fa69fc0d7265ef371e1205e"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84874b530418ba56e2ed9c5c896a9675af1fad0a10f422fd2902faa5862ac978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84874b530418ba56e2ed9c5c896a9675af1fad0a10f422fd2902faa5862ac978"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84874b530418ba56e2ed9c5c896a9675af1fad0a10f422fd2902faa5862ac978"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d40dec4dec58f16ce08afec4ddfae42a9f7b6402b556283578caf226f4b96b6"
    sha256 cellar: :any_skip_relocation, ventura:       "5d40dec4dec58f16ce08afec4ddfae42a9f7b6402b556283578caf226f4b96b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7a6a43ec65a0cc3f7fca3b6544d88f0bd3d5bef067e846edf7b0296776f09e3"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202506050146/geoip.dat"
    sha256 "58bf8f086473cad7df77f032815eb8d96bbd4a1aaef84c4f7da18cf1a3bb947a"
  end

  resource "geoip-only-cn-private" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202506050146/geoip-only-cn-private.dat"
    sha256 "1cc820dfe0c434f05fd92b8d9c2c41040c23c2bfe5847b573c8745c990d5bc98"
  end

  resource "geosite" do
    url "https://ghfast.top/https://github.com/v2fly/domain-list-community/releases/download/20250627153051/dlc.dat"
    sha256 "01dae2a9c31b5c74ba7e54d8d51e0060688ed22da493eaf09f6eeeec89db395e"
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