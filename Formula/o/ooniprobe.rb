class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  # TODO: check if we can build with go1.21
  url "https://ghproxy.com/https://github.com/ooni/probe-cli/archive/refs/tags/v3.20.0.tar.gz"
  sha256 "701bdcbd42ef34fc04b581b278b3cda914c5a78b39bbba9d7ffa74095472bdb2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c97369f89a7267bdf34f502d11eef85f0a1de984ef1662e5542e66b6189e647"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "702b91d47b750ad60c87eae19ea99351ebcc1604ebd136c1e585ac3320f92464"
    sha256 cellar: :any_skip_relocation, ventura:        "23edc2887ad9dee99476091abdbb0af7d2786aca7dba8c806e279a3f511ffe0d"
    sha256 cellar: :any_skip_relocation, monterey:       "8ae2619b7e50e18df603176b9ffeb3d8af6d7a418774d466c9b67cea6581750c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a8a563b82592d101032ca1135362bacf1a090db1160c9a5086a95f3a39ffc1d"
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