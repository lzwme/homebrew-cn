class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:v2fly.org"
  url "https:github.comv2flyv2ray-corearchiverefstagsv5.34.0.tar.gz"
  sha256 "6cf41da0cd786efbc33abf4aa979f934802e33dfe48b5bdfde13e792d4926a08"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https:github.comv2flyv2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2450581e470a6dc44b83f5c12a7441fbfaa44485e3dfdb99769b0cb0cd26cdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2450581e470a6dc44b83f5c12a7441fbfaa44485e3dfdb99769b0cb0cd26cdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2450581e470a6dc44b83f5c12a7441fbfaa44485e3dfdb99769b0cb0cd26cdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f02010e2d01505242723bdb82a7a63af296db6223a948f672bf00c6d5b40abd"
    sha256 cellar: :any_skip_relocation, ventura:       "1f02010e2d01505242723bdb82a7a63af296db6223a948f672bf00c6d5b40abd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "110eba145b23dc23b72f9ff1b254dd54c0d9d0126c54faf6131e8b9b92c2a52e"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202506050146geoip.dat"
    sha256 "58bf8f086473cad7df77f032815eb8d96bbd4a1aaef84c4f7da18cf1a3bb947a"
  end

  resource "geoip-only-cn-private" do
    url "https:github.comv2flygeoipreleasesdownload202506050146geoip-only-cn-private.dat"
    sha256 "1cc820dfe0c434f05fd92b8d9c2c41040c23c2bfe5847b573c8745c990d5bc98"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20250627153051dlc.dat"
    sha256 "01dae2a9c31b5c74ba7e54d8d51e0060688ed22da493eaf09f6eeeec89db395e"
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
    assert_path_exists testpath"log"
  end
end