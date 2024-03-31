class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:xtls.github.io"
  url "https:github.comXTLSXray-corearchiverefstagsv1.8.10.tar.gz"
  sha256 "af5bb501b50e3abe6b54c8d8ea764d7f8b021c4d53540a468254a24f3334afc5"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https:github.comXTLSXray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7900a516a7dfc34dad8a0aabe6f8f05518d77a6bc59f1ef317dd1c4f9db2d3b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "305272c1bafd3838e0f667ea9fc18b2d12dd0a73d6378c36a5e6f8c05b202151"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73ea2aeb9fcbfb40d9883fb982dafe7ba33b518d9e52647a12f9cac669242134"
    sha256 cellar: :any_skip_relocation, sonoma:         "b41f956c8cbd9470c2d61e70141095772c7f01f0648e9f071a9086c0a23aa000"
    sha256 cellar: :any_skip_relocation, ventura:        "2dc93ea7e2f82ebf1170c6387957c8101e84fe6927e0596ac14a5fdcd6f833a2"
    sha256 cellar: :any_skip_relocation, monterey:       "a7d60ee7ef7af372cdb1a0c5972f03e8897371780bbdf5f9e3f90b11117e9e0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd69011b106ed7603fa250852870ec442121ca0d5b4d40ad1a05b6d2fa175e1b"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202403280038geoip.dat"
    sha256 "c4a43c690153b91e69c66808840841dd7fb37e5e6326658c592d32f0519b50f3"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20240324094850dlc.dat"
    sha256 "402d4bdbec16f1d3fce3f5a29dcd5a08725b8e071a507a4b2650d2c2e72f0e9d"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https:raw.githubusercontent.comv2flyv2ray-corev5.14.1releaseconfigconfig.json"
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