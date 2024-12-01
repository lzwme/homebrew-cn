class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:xtls.github.io"
  url "https:github.comXTLSXray-corearchiverefstagsv24.11.30.tar.gz"
  sha256 "1ed728cf32cf9227c73e1b3651465eb089c6d2f42367cf40df62c4ba0edfc765"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https:github.comXTLSXray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34cb663875b8b8f4586387bfdad5c982ea8e49bb2fb262c16b50d97e07ff26f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34cb663875b8b8f4586387bfdad5c982ea8e49bb2fb262c16b50d97e07ff26f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34cb663875b8b8f4586387bfdad5c982ea8e49bb2fb262c16b50d97e07ff26f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa3b28fbab7ce97d309d050354ce1770118617679f58a5ff17937a14ae036eee"
    sha256 cellar: :any_skip_relocation, ventura:       "fa3b28fbab7ce97d309d050354ce1770118617679f58a5ff17937a14ae036eee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ff62b7a7b3dc83e4136636a8238a54c25714ad4ef8672f34cb13def748d9c41"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202411280056geoip.dat"
    sha256 "0b92efbe8e6a8255d3142751964931d2ca4801b51f0cd12c05963e23e0062a52"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20241112092643dlc.dat"
    sha256 "f04433837b88a3f49d7cd6517c91e8f5de4e4496f3d88ef3b7c6be5bb63f4c6f"
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