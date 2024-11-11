class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:xtls.github.io"
  url "https:github.comXTLSXray-corearchiverefstagsv24.11.5.tar.gz"
  sha256 "4610b318778ceca55c83c803fc62064e3379aa6ed33c47499f1483576ea0b41f"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https:github.comXTLSXray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0a95ecce40bcfca9a17b08f7141abcf9b7c8b1152b8aa461f94ae2e209f3d6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0a95ecce40bcfca9a17b08f7141abcf9b7c8b1152b8aa461f94ae2e209f3d6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0a95ecce40bcfca9a17b08f7141abcf9b7c8b1152b8aa461f94ae2e209f3d6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "400afaa9387b8ec926816d1d7bd9d2820dbed04f2981a554ca4babcc005be8af"
    sha256 cellar: :any_skip_relocation, ventura:       "400afaa9387b8ec926816d1d7bd9d2820dbed04f2981a554ca4babcc005be8af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "889e9dbc6e81b3a23ef491175318cf604a1fb47f4e52e1957304fb84c40f0fee"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202410310053geoip.dat"
    sha256 "2762fa0a7d1728089b7723b7796cb5ca955330a3fa2e4407fa40e480fbf9cea7"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20241104071109dlc.dat"
    sha256 "dbda1fe2eeea9cf0ea02f69be0e1db27a5034d331d78f84a1ea6770c1e9f0166"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https:raw.githubusercontent.comv2flyv2ray-corev5.19.0releaseconfigconfig.json"
    sha256 "15a66415d72df4cd77fcd037121f36604db244dcfa7d45d82a0c33de065c6a87"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexecname
    system "go", "build", *std_go_args(output: execpath, ldflags:), ".main"
    (bin"xray").write_env_script execpath,
      XRAY_LOCATION_ASSET: "${XRAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgshare.install resource("geoip")
    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
    pkgetc.install resource("example_config")
  end

  def caveats
    <<~EOS
      An example config is installed to #{etc}xrayconfig.json
    EOS
  end

  service do
    run [opt_bin"xray", "run", "--config", "#{etc}xrayconfig.json"]
    run_type :immediate
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
    output = shell_output "#{bin}xray -c #{testpath}config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath"log", :exist?
  end
end