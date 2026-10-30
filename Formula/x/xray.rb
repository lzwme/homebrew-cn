class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://ghfast.top/https://github.com/XTLS/Xray-core/archive/refs/tags/v26.10.29.tar.gz"
  sha256 "ee22c6f21855f70a52e19bff02fa71f4b28ce071d83ff9154fafcaa0f315a642"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05041f95d1a72d1639a2e046a9d8b98a17b1c8b86b6f6c840fba61fe38585ad2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05041f95d1a72d1639a2e046a9d8b98a17b1c8b86b6f6c840fba61fe38585ad2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "05041f95d1a72d1639a2e046a9d8b98a17b1c8b86b6f6c840fba61fe38585ad2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c2a9f22f36e2a9e276510eac5728220beee8558cef29e594e97c7e977daee5c9"
    sha256 cellar: :any,                 x86_64_linux:      "558f913be653a46610a2560ca7e1df0ab386c90a951ce26ad760c0c830d33615"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://ghfast.top/https://github.com/XTLS/Xray-rules-dat/releases/download/20261028222509/geoip-lite.dat"
    version "20261028222509"
    sha256 "36e0e76145dba3f13ac4bf7be0b738d7eae957835fefd2ee220e7034fe52a4d1"

    livecheck do
      url :url
    end
  end

  resource "geosite" do
    url "https://ghfast.top/https://github.com/XTLS/Xray-rules-dat/releases/download/20261028222509/geosite.dat"
    version "20261028222509"
    sha256 "b8a31ce12d3ec997358bf2bde95be502df7402179d1c93d1e8b3eda6f7b08f3a"

    livecheck do
      url :url
    end
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://ghfast.top/https://raw.githubusercontent.com/v2fly/v2ray-core/v5.55.0/release/config/config.json"
    sha256 "15a66415d72df4cd77fcd037121f36604db244dcfa7d45d82a0c33de065c6a87"

    livecheck do
      url "https://github.com/v2fly/v2ray-core.git"
    end
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    execpath = libexec/name
    system "go", "build", *std_go_args(output: execpath, ldflags: "-buildid="), "./main"
    (bin/"xray").write_env_script execpath,
      XRAY_LOCATION_ASSET: "${XRAY_LOCATION_ASSET:-#{pkgshare}}"

    resource("geoip").stage do
      pkgshare.install "geoip-lite.dat" => "geoip.dat"
    end
    resource("geosite").stage do
      pkgshare.install "geosite.dat"
    end
    pkgetc.install resource("example_config")
  end

  def caveats
    <<~EOS
      An example config is installed to #{etc}/xray/config.json
    EOS
  end

  service do
    run [opt_bin/"xray", "run", "--config", "#{etc}/xray/config.json"]
    run_type :immediate
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
    output = shell_output "#{bin}/xray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_path_exists testpath/"log"
  end
end