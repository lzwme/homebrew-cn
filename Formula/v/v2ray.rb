class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:v2fly.org"
  url "https:github.comv2flyv2ray-corearchiverefstagsv5.33.0.tar.gz"
  sha256 "44b768e0048cf2e68f885f08ceb95ee29eea16a5dbb3b4cb9920d55ce691fa9f"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https:github.comv2flyv2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e4c071729d39d58b71dee78c1a17658b74ad567d77cdddd23c25e869c3382c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e4c071729d39d58b71dee78c1a17658b74ad567d77cdddd23c25e869c3382c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e4c071729d39d58b71dee78c1a17658b74ad567d77cdddd23c25e869c3382c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcd3074a050b6d7cf30729b494307474779c6c325de267e89b7bb951d941f2dd"
    sha256 cellar: :any_skip_relocation, ventura:       "bcd3074a050b6d7cf30729b494307474779c6c325de267e89b7bb951d941f2dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dccfef2d653d5c804b173e3bf0894492de45ae69a3c0f5b3e95e34dcc562e988"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202506050146geoip.dat"
    sha256 "58bf8f086473cad7df77f032815eb8d96bbd4a1aaef84c4f7da18cf1a3bb947a"
  end

  resource "geoip-only-cn-private" do
    url "https:github.comv2flygeoipreleasesdownload202506050146geoip-only-cn-private.dat"
    sha256 "1cc820dfe0c434f05fd92b8d9c2c41040c23c2bfe5847b573c8745c990d5bc98"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20250608120644dlc.dat"
    sha256 "67ededbc0cb18f93415e2e003cb45cb04fc32ba4a829f7d18074d3bdd88ab629"
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
    assert_path_exists testpath"log"
  end
end