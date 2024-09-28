class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:v2fly.org"
  url "https:github.comv2flyv2ray-corearchiverefstagsv5.19.0.tar.gz"
  sha256 "3c1fec2c5fb787d2929ecb68a6d4d3f0afa2d820a2b825d66a1632105864c8f4"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https:github.comv2flyv2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60855abefe1df6ad0596a1a93aff27fd3016b040fadc75063d0ad2089a17878b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60855abefe1df6ad0596a1a93aff27fd3016b040fadc75063d0ad2089a17878b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60855abefe1df6ad0596a1a93aff27fd3016b040fadc75063d0ad2089a17878b"
    sha256 cellar: :any_skip_relocation, sonoma:        "94a27ac68ac7df40f44e05816f8f371dc42ea8a2320e969d4ed177ac4a6d26f5"
    sha256 cellar: :any_skip_relocation, ventura:       "94a27ac68ac7df40f44e05816f8f371dc42ea8a2320e969d4ed177ac4a6d26f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12c474530f91cb0670f964b61f8976b61c9a2e65f5568b3adbddb2eb1789d404"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202409260052geoip.dat"
    sha256 "334bd38a791c41a6b95f3afec7350c8a86ac9b2a9dde1e63c80d183edcb81af4"
  end

  resource "geoip-only-cn-private" do
    url "https:github.comv2flygeoipreleasesdownload202409260052geoip-only-cn-private.dat"
    sha256 "8955e94ffd591755d514e2d9eaa187053e15e514b6c82ba9f3e73d70bfcdbc5c"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20240920063125dlc.dat"
    sha256 "aeefcd8b3e5b27c22e2e7dfb6ff5e8d0741fd540d96ab355fd00a0472f5884a7"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags:, output: libexec"v2ray"), ".main"

    (bin"v2ray").write_env_script libexec"v2ray",
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "releaseconfigconfig.json"

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
    run [opt_bin"v2ray", "run", "-config", etc"v2rayconfig.json"]
    keep_alive true
  end

  test do
    (testpath"config.json").write <<~EOS
      {
        "log": {
          "access": "#{testpath}log"
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
    output = shell_output "#{bin}v2ray test -c #{testpath}config.json"

    assert_match "Configuration OK", output
    assert_predicate testpath"log", :exist?
  end
end