class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  # TODO: check if we can build with go1.21
  url "https://ghproxy.com/https://github.com/ooni/probe-cli/archive/refs/tags/v3.19.1.tar.gz"
  sha256 "e25d5cf6e50b71459f94f75051083f498f8bee287c345b512897576491f70972"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0d5f09e6e1c9d932eb64e5bea2e76adac37b68506d335abe38ade8829fc25e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99e229c7e250f4c891f1a6d9e2f26f96ca0fa6e400276de470a2f045c365148c"
    sha256 cellar: :any_skip_relocation, ventura:        "d34a6873e7838ab7ba8c44807dc1bf9f5a757256c503585d9d9e34361ae3b7dd"
    sha256 cellar: :any_skip_relocation, monterey:       "d8e3571bf2c6f583f996e643738e7093445723dc37787e74d179740869769b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "165f5aa5c0e54a9a84d8c4ed6dbe98cf3a66b675258a171a903d9dbaa7bcf515"
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