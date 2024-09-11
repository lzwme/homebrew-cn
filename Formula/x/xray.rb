class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:xtls.github.io"
  url "https:github.comXTLSXray-corearchiverefstagsv1.8.24.tar.gz"
  sha256 "86e3e388c77cda4d8457a607356416c201c1f18bbed53f0a9e76a228508ff298"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https:github.comXTLSXray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "441bb2842199a775229b590d1f87ce2c3344d255265ea54cc164af64e4977a35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "484206a5e13860d34f6cac072828c39fbbecdbe5c1df9c2c53e8342cad83a57a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "484206a5e13860d34f6cac072828c39fbbecdbe5c1df9c2c53e8342cad83a57a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "484206a5e13860d34f6cac072828c39fbbecdbe5c1df9c2c53e8342cad83a57a"
    sha256 cellar: :any_skip_relocation, sonoma:         "adf5c8959cd593906725d1163943ffe1372a51cbc0c276bcf4fa8b0e17d34eea"
    sha256 cellar: :any_skip_relocation, ventura:        "adf5c8959cd593906725d1163943ffe1372a51cbc0c276bcf4fa8b0e17d34eea"
    sha256 cellar: :any_skip_relocation, monterey:       "adf5c8959cd593906725d1163943ffe1372a51cbc0c276bcf4fa8b0e17d34eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03d0db86ba5d6e05983beaa169b7606f285d754b2ade1fc9748ba9284613becf"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202408290048geoip.dat"
    sha256 "428f8d3c2f65be51afa945a3464b44fde82d509f5df3f1383a5902d1706d1fe4"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20240829063032dlc.dat"
    sha256 "acabd214b0a05363f678baba64dfb745ffc551a9dea6d8c15abe0821a0cac5e9"
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