class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:xtls.github.io"
  url "https:github.comXTLSXray-corearchiverefstagsv24.10.31.tar.gz"
  sha256 "b61102ce87c61fa97c001cb08bb3ad794ff7184e2457bc58fe71206e53dcee83"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https:github.comXTLSXray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62a05f995d4783bbbe62bf262965c7a61446fcbfb5bad868f9670b726cb790f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62a05f995d4783bbbe62bf262965c7a61446fcbfb5bad868f9670b726cb790f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62a05f995d4783bbbe62bf262965c7a61446fcbfb5bad868f9670b726cb790f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7edcc9ab743f6be9f11abea6601541f3bb9fc052917310e88f575c13af58131"
    sha256 cellar: :any_skip_relocation, ventura:       "f7edcc9ab743f6be9f11abea6601541f3bb9fc052917310e88f575c13af58131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17c5bb4d795541223f92b6832fdecb5f581dd8cca29fac1f9c241f85a592933a"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202409260052geoip.dat"
    sha256 "334bd38a791c41a6b95f3afec7350c8a86ac9b2a9dde1e63c80d183edcb81af4"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20240920063125dlc.dat"
    sha256 "aeefcd8b3e5b27c22e2e7dfb6ff5e8d0741fd540d96ab355fd00a0472f5884a7"
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