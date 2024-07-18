class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:xtls.github.io"
  url "https:github.comXTLSXray-corearchiverefstagsv1.8.19.tar.gz"
  sha256 "e0a8032519b76c5d04d9f7ebbeefdbb81f30488f84d534a329b109ea2dd96709"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https:github.comXTLSXray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "535d92454ed8ae360c952f75bd633700cda85d4ff0c8db60e90e6ee69c108acb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17802e47260876b6789c4c49a7c941199fbc47013f4898cc7f2d134f74775724"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae58ee6be1c566bbce2934cb005ea9f3ae0faf9ff86c3841046472deab073aad"
    sha256 cellar: :any_skip_relocation, sonoma:         "84b38542de255274f037f1ddeb1775a7d361c8ed798186c8d9322e20a7b24de2"
    sha256 cellar: :any_skip_relocation, ventura:        "4c2bc07625bb9a9c04b079d995214761f5921d64e8ff780fdf827aa52a457963"
    sha256 cellar: :any_skip_relocation, monterey:       "7886e9700a885f302ff01bdf18426d60891aceee282897c5884811c2ae8065a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eec711375188203d62318fb094a447cbb0654589fd557f5ba6e93a95b4e832e0"
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