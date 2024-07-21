class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:xtls.github.io"
  url "https:github.comXTLSXray-corearchiverefstagsv1.8.20.tar.gz"
  sha256 "602b04dc305086c3a1206395858e4eff6ccdffc799556521f1d830b3bc715fbc"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https:github.comXTLSXray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "260a78ddc73de36d6d31d3253dff841b6affabb7432f0ecb6aef909fe1d2d9ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "511d48c32e0d3757ab876215d55ec1879f20dd71f70026311b6ab5c439209982"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9169005901c4f0815b08db139ff24ac3bcf6d2786f8e04e14997ac7377e2f9a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "56f448a472ec19b7ade3141812287a5bdaad06083a86dcf335487add01f241fa"
    sha256 cellar: :any_skip_relocation, ventura:        "1d4f81b3901ae740291b30131dae14d5acccd1350d755a55cf33e74c7af5374c"
    sha256 cellar: :any_skip_relocation, monterey:       "a7284034ce292c248367eccf9ae51a8697751c2aadb1ccca999f9cd4aedfa03e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dc1ab15eca229269f10fe09ee54148b2915442023f2d288c8056fab8de128e3"
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