class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:v2fly.org"
  url "https:github.comv2flyv2ray-corearchiverefstagsv5.12.1.tar.gz"
  sha256 "fa1845d42b46c6b5046a8f95d49cc7a9175e40efc5c13b95174b4c556567aca1"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https:github.comv2flyv2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eae3701bdaf666ca097a4f184c5bf73c93429ae7d9ed60cc10f4d8866b61a6c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1afea96e6198891e222858474452609898619b7a636d60d3fa5722d0c24ba201"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aaa307d9945db223d92baae0ec64194b3d8db237b3ec250d45ecbe1b2e9d84e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3065a952a3f8402b9a41523cb5bbd2d86531a714a237940baa4d2f4d9b86b82"
    sha256 cellar: :any_skip_relocation, ventura:        "0a1e2b60018ed702d4d07c3a80e9571e1496e4c0e09dab5f38a440bcfd1dc0e1"
    sha256 cellar: :any_skip_relocation, monterey:       "dcc7f7641000ee1769dcbaca7038ca16ba84a0a642711abe9c987d080a9494c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "625a8677fafcc29e215468e831a991d477fc2e7708b1c566d1d1c46fd7edf3c1"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202311230040geoip.dat"
    sha256 "1719c271db87f88c3480baffa61b02e28440fc3561fa031482d5fd928d13ad61"
  end

  resource "geoip-only-cn-private" do
    url "https:github.comv2flygeoipreleasesdownload202311230040geoip-only-cn-private.dat"
    sha256 "3102515134af15e30cd9c047081a63be760d435d3399c264e2d242c10e78dcaf"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20231122065640dlc.dat"
    sha256 "469fdf0e2ff6dea1ec347dc639453f7007ce96fc594861fc9a443ef709970b01"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags: ldflags, output: libexec"v2ray"), ".main"

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