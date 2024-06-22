class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:xtls.github.io"
  url "https:github.comXTLSXray-corearchiverefstagsv1.8.16.tar.gz"
  sha256 "61a96fba9ae18e91ea163f317a3641bca21fa744c214fb912270a3e6b7a8da6d"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https:github.comXTLSXray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3147f01b8654e14d62fb71b9c68b32ff7833fd4dea1c43ea65b522df5f55b5bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c49be2901dcb9ac9dad8b1e7e95b6dbc29413b962b3218c41fd0ee75af27d402"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37b34e7e9940b46f27b5a200fdff2bc60a9fe17e05d7e9866222ffa09cff4df7"
    sha256 cellar: :any_skip_relocation, sonoma:         "425d60f39edb4ee2239a87cacc0287c43dfe694e184a8eeb9c9fda6deff8ee16"
    sha256 cellar: :any_skip_relocation, ventura:        "9ec78e5d3ec1fb29f58325660411cfe228291743efe75cfbe05079b388e59994"
    sha256 cellar: :any_skip_relocation, monterey:       "c8886f9561854ae978e9472843d84d53490d986dfdaeeb989e743d796f24163c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "454045bbf201330c76e7107a853fd6645e22e9c48b2fcd267b1ed3eb112d913d"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202406200042geoip.dat"
    sha256 "4d65e0bfc4976c65d7ce2c77ae7c06fe8bf8ab852c3d83bd2a2fa1f952e556e5"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20240614093027dlc.dat"
    sha256 "d3d6482b9a1d8a875ae86756058e7693bb8ce7b476f690b191498d854fe16e76"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https:raw.githubusercontent.comv2flyv2ray-corev5.15.3releaseconfigconfig.json"
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