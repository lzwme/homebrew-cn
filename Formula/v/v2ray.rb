class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https:v2fly.org"
  url "https:github.comv2flyv2ray-corearchiverefstagsv5.13.0.tar.gz"
  sha256 "6b2eb6286c99da010db5c5f629f950e753fc4addeed189d3d898c1ef56d5a785"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https:github.comv2flyv2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55671dba9ee2db40fff31c63bdd0d75b716e6035229eb561783f1c8d20ac640a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d6930a16f74b78793a9169224cd2a369857c40f8d4eee3e7f29ba65d3f9fe8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f456531da3a3162c93493d8cc942bbff0ec8f3ef3297ad1234868af09c561711"
    sha256 cellar: :any_skip_relocation, sonoma:         "75722e12fd30cd78acfdb9f213afc5a4cc3312ce199da0e7e180fb022ed5edd6"
    sha256 cellar: :any_skip_relocation, ventura:        "09a3c95695dc0e658945ca560749fe2d7d61cdfdd3e4807d9b77efab2c87e59f"
    sha256 cellar: :any_skip_relocation, monterey:       "b02e559649e7fe9a63f4ddc8acfc46d09adaa1e59bdcc06c38bb9d7d63e7dc09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b968615441aba4842925df6d6f70a1adbbc208934b55e99a128f68c469dbe82e"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202402290038geoip.dat"
    sha256 "8463e06eb8a15d11dcb6c134002a443cab447c7e46844352f5dd8eaa661350f4"
  end

  resource "geoip-only-cn-private" do
    url "https:github.comv2flygeoipreleasesdownload202402290038geoip-only-cn-private.dat"
    sha256 "c21fe12f4f8cb028113c55142fb5e651e60a2fefe44c484a4dccd5e1c0d70724"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20240301033006dlc.dat"
    sha256 "9df541a638027d9ae4c08507c1e71d543d57af067542f455a207c6d8dac7e0f6"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags: ldflags, output: libexec"v2ray"), ".main"

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