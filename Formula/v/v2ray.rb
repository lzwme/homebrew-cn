class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://ghfast.top/https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.42.0.tar.gz"
  sha256 "24e2182bf77342165511150db014668723ac4a0c9e72269b0590b0be72875b49"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caf5b77d2513aa305aa5ff24cd5f4384781e42778bc38ba381ec6e14a0c7a83d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caf5b77d2513aa305aa5ff24cd5f4384781e42778bc38ba381ec6e14a0c7a83d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caf5b77d2513aa305aa5ff24cd5f4384781e42778bc38ba381ec6e14a0c7a83d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab661ebc2aaf622c243583ad25c34b0cc5294383a705a9932b4a0ee13f41c902"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d0fe784ec60a9bcb0ccba6a55154c8e39be97122229e22f5e4bde08fa52efde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af1b19498c1a07872520b42202223b8a100490a33938bd8afd70eb04960d3e63"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202512201334/geoip.dat"
    sha256 "6878dbacfb1fcb1ee022f63ed6934bcefc95a3c4ba10c88f1131fb88dbf7c337"
  end

  resource "geoip-only-cn-private" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202512201334/geoip-only-cn-private.dat"
    sha256 "853258a1c019e1350664ab808e8ca48acf62124e81344298fba0389c2af81340"
  end

  resource "geosite" do
    url "https://ghfast.top/https://github.com/v2fly/domain-list-community/releases/download/20251229125847/dlc.dat"
    sha256 "76a04c2cdc92fe224f6367112fb67a7593b0882784aebecba66f8a531777b241"
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