class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:xtls.github.io"
  url "https:github.comXTLSXray-corearchiverefstagsv1.8.18.tar.gz"
  sha256 "088248fe9d06c0a8964b8815edc6099cb50a7fe2b36633681829097903470ac1"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https:github.comXTLSXray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e80539942154ea8177c36ae72355f611960ffad86057f455ae6b2ab9cfaa485"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "559f763913a04b4f77c077218649a15f57d761ab12ca12df66162af0493f529c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acabfbdd671853918dda0a7cae02900a58fa5155141613d8f4a32123b71a381f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a591058bd699334469074308e160405bdaae38099a9070ce914839641813a39a"
    sha256 cellar: :any_skip_relocation, ventura:        "e5efc3d308b30d91856692ee8a4eb8e267dabc7d5ad204afea77029eb56dfdf2"
    sha256 cellar: :any_skip_relocation, monterey:       "7f9a47f7aac5a6ffbdde7f41bd18682016e5fd0f05f4153524e4504e22e1a23a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56bb19e07a71601e2073dd3eb9dc68f73c71edd9e46f8289181586d86ba64884"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202407110044geoip.dat"
    sha256 "83c8d38a4fff932fcbfe726c1f85c0debb1bf169afcfa18566c731a2f2c1f7b6"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20240713050854dlc.dat"
    sha256 "dbaba085b1de1b8b875f3db78fb367aef080f24993af01abe21f4d4ba99048be"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https:raw.githubusercontent.comv2flyv2ray-corev5.16.1releaseconfigconfig.json"
    sha256 "1bbadc5e1dfaa49935005e8b478b3ca49c519b66d3a3aee0b099730d05589978"
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
    output = shell_output "#{bin}xray -c #{testpath}config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath"log", :exist?
  end
end