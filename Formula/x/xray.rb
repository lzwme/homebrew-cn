class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:xtls.github.io"
  url "https:github.comXTLSXray-corearchiverefstagsv1.8.21.tar.gz"
  sha256 "464636c323c20cd17a6e10d6fdf0120f0a84096f1c66c0ab4851141d238a1a0b"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https:github.comXTLSXray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0679d2ec0c959ac128e6b02581d74a579df0b720ee81626956678633a4bafb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0340d1e93862b01ba0664f0ef096696e8431ca37c388ca1cfef078c245df1edc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66f29747c8b3b0090df6225f9b4721657d3301c223018b7085d8d363726e94e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "53413bd59608f3ab129c11c501b753c2c5dde48726ed0d5e4e0885705d3450e6"
    sha256 cellar: :any_skip_relocation, ventura:        "b57099fef453cc30b0c426a1be27c1cc8576aa436290a04e649ced5d598b3ecc"
    sha256 cellar: :any_skip_relocation, monterey:       "2a8f3f1e60101c06b07dc7771ada507b9150d98953c1e52303561564245005a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccdfdedfab174ea3dadfe6d2885012f5372ecef819d88901c9fb969bd7fc69d6"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202407192357geoip.dat"
    sha256 "8128db0c1431f4c6854dfb7740b497ee0ac73f0f3a52a1e0040c508f7d79c0a4"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20240720181558dlc.dat"
    sha256 "873ad7f4ad185ba7a70c5addbfd064703f22a7a8e4e21e4114a8ea98da7dd5ad"
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