class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:xtls.github.io"
  url "https:github.comXTLSXray-corearchiverefstagsv24.12.18.tar.gz"
  sha256 "3d8b4a161a263e7af7bb1a2690961da075d13f980acd806f5cd4e5c8338d7534"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https:github.comXTLSXray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a3f4e333a11469099cd52678f79af2ac97acb10dc338b0e79e53a67af61ce26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a3f4e333a11469099cd52678f79af2ac97acb10dc338b0e79e53a67af61ce26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a3f4e333a11469099cd52678f79af2ac97acb10dc338b0e79e53a67af61ce26"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb9d6eea49785c8b4764de022abf14967c2c39117a024ffba9df32a72d47bde1"
    sha256 cellar: :any_skip_relocation, ventura:       "cb9d6eea49785c8b4764de022abf14967c2c39117a024ffba9df32a72d47bde1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e723e98859e229d56e852407bb70c3d2eef194591bad0bbb78d8e1b778093523"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202412120057geoip.dat"
    sha256 "5a184de8e36b5b131e405eb1078856703c0727f097636529cbbe47f38f2fe92d"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20241210004721dlc.dat"
    sha256 "e414da6132d8b406827b827f246c3fe9759530d61f191b866836fe4d0a7b13a4"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https:raw.githubusercontent.comv2flyv2ray-corev5.22.0releaseconfigconfig.json"
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