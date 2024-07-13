class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:xtls.github.io"
  url "https:github.comXTLSXray-corearchiverefstagsv1.8.17.tar.gz"
  sha256 "390745e9f8afbd1cd584344a34709f13b9465bb887c7a4f993696ee8cf706b83"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https:github.comXTLSXray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2740f286813b76c22925909950cde0cfdd11a8c61e98994ceb5b298e00b5d01b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b574c6483f23da160227355237aae2ddc46f000a1b575ec72e05985a766daa3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a47e2f540cd844539173e2b70ebc371aa297154fa58f48cc1bcab76409e11c0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "daad312586d79e734693099360f1ac7f95e57109f2b955be54d1b0b65da14655"
    sha256 cellar: :any_skip_relocation, ventura:        "e57adc7d25347b55b99fa7a55c1b9d94c6ef55d6166ae6e357e33b6ec5a9c561"
    sha256 cellar: :any_skip_relocation, monterey:       "a37e067d32b481e9f1632ec32b308195d65188be7dae72deef97e4f580f63852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de52d5b9d39dafba86770588a1f430827f564b4a3c620aebbd9cacf56eccc4a5"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202407110044geoip.dat"
    sha256 "83c8d38a4fff932fcbfe726c1f85c0debb1bf169afcfa18566c731a2f2c1f7b6"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20240710044910dlc.dat"
    sha256 "5dad9aa8bbbd4a2a3938f7be16236703de6ab15c6416bf7b727ec0a7831e5e6a"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https:raw.githubusercontent.comv2flyv2ray-corev5.15.3releaseconfigconfig.json"
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