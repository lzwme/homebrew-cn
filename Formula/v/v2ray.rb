class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:v2fly.org"
  url "https:github.comv2flyv2ray-corearchiverefstagsv5.21.0.tar.gz"
  sha256 "880a929caff7b72ef9d3b9a3262cec0dff6566c2481989822a6b27fdaaeed975"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https:github.comv2flyv2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "558c6bccde42c4dcb7a6d7eb57dad73afa5734cc7a26ecf894490e59f241bf2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "558c6bccde42c4dcb7a6d7eb57dad73afa5734cc7a26ecf894490e59f241bf2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "558c6bccde42c4dcb7a6d7eb57dad73afa5734cc7a26ecf894490e59f241bf2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c78cf5df23f9e12ffd062388be3cc2854dfe086d30f3c8ef3237277e4b0e685"
    sha256 cellar: :any_skip_relocation, ventura:       "7c78cf5df23f9e12ffd062388be3cc2854dfe086d30f3c8ef3237277e4b0e685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d48ba94394072931a225c3099361411deb8123b2003fadd3fbf3677430b5f3"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202410170052geoip.dat"
    sha256 "6f5b65aee82da0415bfbe87903673cd006183f8833659646fca6b531e8c155ea"
  end

  resource "geoip-only-cn-private" do
    url "https:github.comv2flygeoipreleasesdownload202410170052geoip-only-cn-private.dat"
    sha256 "37541ed2186d7fe661580e680cc5ed89f554fb02fad1acf6951361696eee6e6f"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20241013063848dlc.dat"
    sha256 "f820556ed3aa02eb7eadba7a3743d7e6df8e9234785d0d82d2d1edce20fe4b3c"
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
    output = shell_output "#{bin}v2ray test -c #{testpath}config.json"

    assert_match "Configuration OK", output
    assert_predicate testpath"log", :exist?
  end
end