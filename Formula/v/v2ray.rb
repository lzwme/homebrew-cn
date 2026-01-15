class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://ghfast.top/https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.43.0.tar.gz"
  sha256 "e8e61a2ec0ec124d00922578ea2e194c953baeb633668f1a6b1339c8d8125cd6"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf641169a1faec6c2e711856f2092d39c58eb1343851b65b8352ac078f749a14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf641169a1faec6c2e711856f2092d39c58eb1343851b65b8352ac078f749a14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf641169a1faec6c2e711856f2092d39c58eb1343851b65b8352ac078f749a14"
    sha256 cellar: :any_skip_relocation, sonoma:        "454bfef863a38286f6ec0fe8c9d9d2d1b9615dc522b214d43e06dc4587135fc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7efba8d414eaa8304fb6efe366d8748f30cf27b26bce0891b2af6d79c9c5ee6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1e0ccaaae09cca0a7aa423a9f077c2afc8bb7bcc8613291cb336e7fffe6f4d9"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202601050204/geoip.dat"
    sha256 "ed2de9add79623e2e5dbc5930ee39cc7037a7c6e0ecd58ba528b6f73d61457b5"
  end

  resource "geoip-only-cn-private" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202601050204/geoip-only-cn-private.dat"
    sha256 "41d23732ab1b4b08326c356c63656aac3727f1eed5d5828d7ceafe7dbb121662"
  end

  resource "geosite" do
    url "https://ghfast.top/https://github.com/v2fly/domain-list-community/releases/download/20260114095327/dlc.dat"
    sha256 "6f000a21368d702f6c05bcf4ad62d9aebe5a0055f0a171bf2af7dff9393c8d20"
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