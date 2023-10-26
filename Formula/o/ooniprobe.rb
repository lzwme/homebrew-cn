class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  # TODO: check if we can build with go1.21
  url "https://ghproxy.com/https://github.com/ooni/probe-cli/archive/refs/tags/v3.19.0.tar.gz"
  sha256 "9ec38edb7bb4254e16a58f184ddceafc4a0ede060e08f6741ab02d1e7d6820a2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4995f93bb678d34dd7f348ea1ff5633db41e5964d62830dc4512be145e8057c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62b9b9595774096e75061b8ce9bf058c0e56d8a3a5b33b1ed74a01fe9c16f582"
    sha256 cellar: :any_skip_relocation, ventura:        "f717726bff1eb2824ca9b97e53114c371eab96dac46d1ced7d9cf87d2c852b87"
    sha256 cellar: :any_skip_relocation, monterey:       "1c11c5e783a47c1698f5f45ec164d93d9d1eea0eff983cc7941767531e027c7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a6e054572e1399860103cad22cc42089b0e1d1bd9de682bee25fe7eda031109"
  end

  # go1.21 build issue report, https://github.com/ooni/probe/issues/2585
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
        "_informed_consent": true,
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
          "send_crash_reports": true,
          "collect_usage_stats": true
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