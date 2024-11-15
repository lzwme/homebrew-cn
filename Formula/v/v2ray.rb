class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:v2fly.org"
  url "https:github.comv2flyv2ray-corearchiverefstagsv5.22.0.tar.gz"
  sha256 "df25a873c8f7fb30f44cb6d26b18db264dfa209df5aeb6116fc43df7157fb4b8"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https:github.comv2flyv2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5726a5658386c3946dad3b0a5ba3ec94d6f15ca2c7938118c46fe6752bcd1590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5726a5658386c3946dad3b0a5ba3ec94d6f15ca2c7938118c46fe6752bcd1590"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5726a5658386c3946dad3b0a5ba3ec94d6f15ca2c7938118c46fe6752bcd1590"
    sha256 cellar: :any_skip_relocation, sonoma:        "088b3d50e870d39c5b8ad2aaa707336cc82c5d41a6fb99948e4684c9476e929b"
    sha256 cellar: :any_skip_relocation, ventura:       "088b3d50e870d39c5b8ad2aaa707336cc82c5d41a6fb99948e4684c9476e929b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1bdd7e215ad00e02f2582963a9cbca5e76c443400a1a90fd2aa2a2ff039dbfc"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202411140052geoip.dat"
    sha256 "c9114fd3157e44f1234976a3cba6d8ffee28fb8331890f0909d64e5b6677494e"
  end

  resource "geoip-only-cn-private" do
    url "https:github.comv2flygeoipreleasesdownload202411140052geoip-only-cn-private.dat"
    sha256 "9c437ba446690a2c9be5343ec1c4ab904578a164212fb8c3ea2808d7e78518f7"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20241112092643dlc.dat"
    sha256 "f04433837b88a3f49d7cd6517c91e8f5de4e4496f3d88ef3b7c6be5bb63f4c6f"
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
    (testpath"config.json").write <<~JSON
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
    JSON
    output = shell_output "#{bin}v2ray test -c #{testpath}config.json"

    assert_match "Configuration OK", output
    assert_predicate testpath"log", :exist?
  end
end