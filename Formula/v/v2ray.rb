class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:v2fly.org"
  url "https:github.comv2flyv2ray-corearchiverefstagsv5.23.0.tar.gz"
  sha256 "ae02fa91d2cbb1fc909bd3e7421a046319f1d8734170ff434234940bd3aa4364"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https:github.comv2flyv2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8445ca58b20bfd09f2b23b03eaffbfe4aaa4a8d700e42ce91b97f7d71f6bb0f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8445ca58b20bfd09f2b23b03eaffbfe4aaa4a8d700e42ce91b97f7d71f6bb0f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8445ca58b20bfd09f2b23b03eaffbfe4aaa4a8d700e42ce91b97f7d71f6bb0f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "082d5d7df87e2bcfb567632a23ba18608f1fb0e30e2d9ebcf6e5a1fdd359cfba"
    sha256 cellar: :any_skip_relocation, ventura:       "082d5d7df87e2bcfb567632a23ba18608f1fb0e30e2d9ebcf6e5a1fdd359cfba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be68fd151538e56bcbd0215efd108d67c76b7c953c96b52b6aa5a8395c797015"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202501020052geoip.dat"
    sha256 "dba9102d288936e3b9b6511c0d0b03e62865c130a2263cb4719ad80b7a9f69bf"
  end

  resource "geoip-only-cn-private" do
    url "https:github.comv2flygeoipreleasesdownload202501020052geoip-only-cn-private.dat"
    sha256 "db672a549a0ac8c3774eaf83ac32629a8f352af092bf004ca62a3bdce27b07f9"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20241221105938dlc.dat"
    sha256 "aa65cee72dd6afbf9dd4c474b4ff28ceb063f6abf99249a084091adb4f282f09"
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