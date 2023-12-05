class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  # TODO: check if we can build with go1.21
  url "https://ghproxy.com/https://github.com/ooni/probe-cli/archive/refs/tags/v3.19.2.tar.gz"
  sha256 "aefc8dad948cdc4a7269bf223c4cdccb6f31fdc153c1e857a9364e195e67cf47"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "975d29ac01455f0eb6a3bbd8303a847147a5d8fa20eaf82e1047f13d2ee3e9dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5e6c5ab8ab8465deace688f926dd37935f4509887e82847e06b8f8728e7b569"
    sha256 cellar: :any_skip_relocation, ventura:        "a306e9e94ad00f66e579f39e14fd76294c51e2cc70a42b247ab7595f5b62ea28"
    sha256 cellar: :any_skip_relocation, monterey:       "bef20fd8ef1a5c50d38af4c5d2f6421dec9e2f7aabb5ec7b02ed9c89687b53d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "808907b8bec02270444786ff87e98b17f37f39a3e96c6fb71b6c114b099eb3c4"
  end

  # go1.21 build issue report, https://github.com/ooni/probe/issues/2548
  depends_on "go@1.20" => :build
  depends_on "tor"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ooniprobe"
    (var/"ooniprobe").mkpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ooniprobe version")

    # failed to sufficiently increase receive buffer size (was: 208 kiB, wanted: 2048 kiB, got: 416 kiB).
    return if OS.linux?

    (testpath/"config.json").write <<~EOS
      {
        "_version": 3,
        "_informed_consent": false,
        "_is_beta": false,
        "auto_update": false,
        "sharing": {
          "include_ip": false,
          "include_asn": true,
          "upload_results": false
        },
        "nettests": {
          "websites_url_limit": 1,
          "websites_enabled_category_codes": []
        },
        "advanced": {
          "send_crash_reports": false,
          "collect_usage_stats": false
        }
      }
    EOS

    mkdir_p "#{testpath}/ooni_home"
    ENV["OONI_HOME"] = "#{testpath}/ooni_home"
    Open3.popen3(bin/"ooniprobe", "--config", testpath/"config.json", "run", "websites", "--batch") do |_, _, stderr|
      stderr.to_a.each do |line|
        j_line = JSON.parse(line)
        assert_equal j_line["level"], "info"
      end
    end
  end
end