class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://ghfast.top/https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.52.0.tar.gz"
  sha256 "b44f615b17bf627505b329a935568a5864a0d0cc071a5d7a71369da6f232f800"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd5f89040e15289a7f10c6681ccb68f163d77a4a76a8cdb1f180623159ca5b4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd5f89040e15289a7f10c6681ccb68f163d77a4a76a8cdb1f180623159ca5b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd5f89040e15289a7f10c6681ccb68f163d77a4a76a8cdb1f180623159ca5b4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "04d76d088a68e456a9e1c1bd9a7b0123c81a9809c20abc499823272e65043bdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b93f41f90d34119ae5596ddaa07b45afbdaf7cb8fc8f38f9424a68848e9d25d"
    sha256 cellar: :any,                 x86_64_linux:  "5e35ae752143c78db8fab3dc5d40235e78dd09b767bf9df41b286498669fa619"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202607171233/geoip.dat"
    version "202607171233"
    sha256 "b71d1999439dde2de2d2b6844a2befa50c50211ff739785c005ca7c230a17d6a"

    livecheck do
      url :url
    end
  end

  resource "geoip-only-cn-private" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202607171233/geoip-only-cn-private.dat"
    version "202607171233"
    sha256 "dff2733e43dbbdae88b2a59f908572eb5d9267d4afdb4c456a17f4a49d36747f"

    livecheck do
      url :url
    end
  end

  resource "geosite" do
    url "https://ghfast.top/https://github.com/v2fly/domain-list-community/releases/download/20260801163240/dlc.dat"
    version "20260801163240"
    sha256 "d0288dd63ac15195655766da1b49925d05f001aaa30783a5d51c805c4b989fbe"

    livecheck do
      url :url
    end
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-buildid=", output: libexec/"v2ray"), "./main"

    (bin/"v2ray").write_env_script libexec/"v2ray",
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

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
    run [opt_bin/"v2ray", "run", "-config", etc/"v2ray/config.json"]
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~JSON
      {
        "log": {
          "access": "#{testpath}/log"
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
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_path_exists testpath/"log"
  end
end