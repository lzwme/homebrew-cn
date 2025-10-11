class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://ghfast.top/https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.40.0.tar.gz"
  sha256 "14e333c7454781f0b44fe9cba1616e25accfb04cf0d9d31db7acdd33e2e8d0ac"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0051a9c23dfde63f18af63cf4a11e51f7ac8f4f29d8b85fb403439430fde6627"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0051a9c23dfde63f18af63cf4a11e51f7ac8f4f29d8b85fb403439430fde6627"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0051a9c23dfde63f18af63cf4a11e51f7ac8f4f29d8b85fb403439430fde6627"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fed57d874e8270d1afdb19dd1352a2e491d7a99b521a7a20920b8160e200a5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75d11a1df1a8c70c4daab36cc05e89268b937808a4081039669369cc265285e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f0f37d9b02c3327815ca27865ac9bf00a2788afff2ac2662c642efebb0d6946"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202510050144/geoip.dat"
    sha256 "c23ac8343e9796f8cc8b670c3aeb6df6d03d4e8914437a409961477f6b226098"
  end

  resource "geoip-only-cn-private" do
    url "https://ghfast.top/https://github.com/v2fly/geoip/releases/download/202510050144/geoip-only-cn-private.dat"
    sha256 "62a303deff40ce0d3735c2dc974b832f85b5f21892b03b0b4ae2acb53717d730"
  end

  resource "geosite" do
    url "https://ghfast.top/https://github.com/v2fly/domain-list-community/releases/download/20250916122507/dlc.dat"
    sha256 "1a7dad0ceaaf1f6d12fef585576789699bd1c6ea014c887c04b94cb9609350e9"
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