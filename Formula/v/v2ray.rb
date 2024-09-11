class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:v2fly.org"
  url "https:github.comv2flyv2ray-corearchiverefstagsv5.17.1.tar.gz"
  sha256 "e6798d1a29f6a52a3c0cc7176803b73e292427bc7858d534d0529a278936b8b0"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https:github.comv2flyv2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "69ec0da071aaf89d8342eeaa5f08710dd618df50a2d4a5f6bb4e7fc3eb81e113"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69ec0da071aaf89d8342eeaa5f08710dd618df50a2d4a5f6bb4e7fc3eb81e113"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69ec0da071aaf89d8342eeaa5f08710dd618df50a2d4a5f6bb4e7fc3eb81e113"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69ec0da071aaf89d8342eeaa5f08710dd618df50a2d4a5f6bb4e7fc3eb81e113"
    sha256 cellar: :any_skip_relocation, sonoma:         "59cc9e9133d774d387f10549dfb7130a9f9fc37a8c8baa6250952ed3a46722bc"
    sha256 cellar: :any_skip_relocation, ventura:        "59cc9e9133d774d387f10549dfb7130a9f9fc37a8c8baa6250952ed3a46722bc"
    sha256 cellar: :any_skip_relocation, monterey:       "59cc9e9133d774d387f10549dfb7130a9f9fc37a8c8baa6250952ed3a46722bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "affaea1fc03a3b360c0563ddaf05f6e8bcaf30d384dd7c4484769cb9dd3bfcba"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202404180039geoip.dat"
    sha256 "a0ba7f1aa6fc85c20d6e17c4696cee28bc45784cf2b04c2891f8b6f2eb653d9a"
  end

  resource "geoip-only-cn-private" do
    url "https:github.comv2flygeoipreleasesdownload202404180039geoip-only-cn-private.dat"
    sha256 "156b2c15660f8f8f2d1bc83522cf921603ed8456db3bf671d802111b207f8b9e"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20240422085908dlc.dat"
    sha256 "18b5b7f44471d27781a53933bd71e2d9fddf5549c06003aadfda8afca3c3eb1e"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags:, output: libexec"v2ray"), ".main"

    (bin"v2ray").write_env_script libexec"v2ray",
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "releaseconfigconfig.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [opt_bin"v2ray", "run", "-config", etc"v2rayconfig.json"]
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
    output = shell_output "#{bin}v2ray test -c #{testpath}config.json"

    assert_match "Configuration OK", output
    assert_predicate testpath"log", :exist?
  end
end