class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://ghfast.top/https://github.com/ooni/probe-cli/archive/refs/tags/v3.27.0.tar.gz"
  sha256 "6f52c75c9d09866265ed0e2a025d9b78daa2e165c6c2ff79d14a8a9ea10df4f7"
  license "GPL-3.0-or-later"
  head "https://github.com/ooni/probe-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "641cb450eb42b22d54cbf90b6d09c131ab2c51e1b6f961718e9199c4ca063641"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20fca266bd3ba2e8aaa7e4f1d4cac5247930f4644fb57abf1337a0e3a52852e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0475debc2e040810340a57ff648b5cf887a54f40879edb9fea1a57593d94e8a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3399432333f980d7db14e51d293610f3a839e107dc1d90b3ca2cac3f81e29cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77ad08b39da3a39a68f741f11513cb7817a87f99f3716097499ac485ecb32dcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70740b906739c8eb107db725718f3ba1ceed246cf755f6b1502dc2194d6cb192"
  end

  depends_on "go" => :build
  depends_on "tor"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ooniprobe"
    (var/"ooniprobe").mkpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ooniprobe version")

    # failed to sufficiently increase receive buffer size (was: 208 kiB, wanted: 2048 kiB, got: 416 kiB).
    return if OS.linux?

    (testpath/"config.json").write <<~JSON
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
    JSON

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