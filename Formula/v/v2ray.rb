class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:v2fly.org"
  url "https:github.comv2flyv2ray-corearchiverefstagsv5.18.0.tar.gz"
  sha256 "15acf65228867d47dcab27f87af048a2f0e6ed5d347a2e68730d30ae2a3871eb"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https:github.comv2flyv2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfa73ea76925010f6c50dc9f3bad887850b646a634fcfd6f9b21125dde4b88b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfa73ea76925010f6c50dc9f3bad887850b646a634fcfd6f9b21125dde4b88b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfa73ea76925010f6c50dc9f3bad887850b646a634fcfd6f9b21125dde4b88b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "633548415c2486556f184891782675e41d6d050653a0232ee6bd6e5ae44b9798"
    sha256 cellar: :any_skip_relocation, ventura:       "633548415c2486556f184891782675e41d6d050653a0232ee6bd6e5ae44b9798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78f2225a7962a84e79f7440fcdd86fbcfb1d25a800d953ccccdce35379636df6"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202409120050geoip.dat"
    sha256 "4ec83c46f84b3efb9856903e7c10d6c21f6515b9e656575c483dcf2a3d80f916"
  end

  resource "geoip-only-cn-private" do
    url "https:github.comv2flygeoipreleasesdownload202409120050geoip-only-cn-private.dat"
    sha256 "0b8ba93300d5cfce40f2f0035c5179e875f68b2d1b879d24a0c343f93ad61c03"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20240914091803dlc.dat"
    sha256 "c171f61d3ba8e0dcf31a9548e9fd928a9416e064ad9417664eadda8d25eb6ad9"
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