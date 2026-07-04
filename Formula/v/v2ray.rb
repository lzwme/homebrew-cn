class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://ghfast.top/https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.49.0.tar.gz"
  sha256 "1a63c9179497db2d6bb7027eed5653d2b1dd3e9942b656146e87a7fd28f1d22b"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c174faed11802c0fe249ca65c4a700ac4578506ba113ccde5b48749543f2bcb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c174faed11802c0fe249ca65c4a700ac4578506ba113ccde5b48749543f2bcb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c174faed11802c0fe249ca65c4a700ac4578506ba113ccde5b48749543f2bcb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "07a19f492efd8c14cf9cc37d866089976ec399669ba7ebb19a3f774937a82649"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a4276f4aac894ae4e657e344435ac7f3b111da78cfe954051bc44e512592e13"
    sha256 cellar: :any,                 x86_64_linux:  "77ce611cbc275ca0dae984f54173cc352dff0667e99115b5b4b83f2a9a65ae82"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202607020247/geoip.dat"
    sha256 "b71d1999439dde2de2d2b6844a2befa50c50211ff739785c005ca7c230a17d6a"
  end

  resource "geoip-only-cn-private" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202607020247/geoip-only-cn-private.dat"
    sha256 "dff2733e43dbbdae88b2a59f908572eb5d9267d4afdb4c456a17f4a49d36747f"
  end

  resource "geosite" do
    url "https://ghfast.top/https://github.com/v2fly/domain-list-community/releases/download/20260702133809/dlc.dat"
    sha256 "f2ec0b9dc07c03af30d61f84d0d07210235fcc226a9c2b6682717bada6e58c12"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags:, output: libexec/"v2ray"), "./main"

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