class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://ghproxy.com/https://github.com/ooni/probe-cli/archive/v3.17.3.tar.gz"
  sha256 "1a0515ae95464c406b0c5d97d6638640c61ec3f94dab14559151c76e809140f2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c977844d2d0f760c459adc8eb8e5b9568a2d4ee953074458b6ae2e2720601db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb9d0a80165fea45c36e70a9c7908d1e2e3050f4a0e7d5cd9a6d95aac994b21a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43c546266465bf63153a627bb8d902f2618186c6790e9158558cc69faea709a9"
    sha256 cellar: :any_skip_relocation, ventura:        "05e1daa47a65fe366888ad0d27daab29f741ee76c91aa92b9034290c92a418c2"
    sha256 cellar: :any_skip_relocation, monterey:       "2cb4303db22f48fda994bb7909245db9a9304df9c510cdcf8e5b96628d0d294c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd22f0a1e858620c13ae1423c34bc3fe7e4f0c07b67169b92f31623167a8263f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dd53e5f4a3cbe119374a806cee77b7f4b894180b5a588bf81c6d4771c448295"
  end

  # Upstream does not support go 1.20 yet and recommends using a specific Go version:
  # https://github.com/ooni/probe-cli/blob/v#{version}/GOVERSION
  depends_on "go@1.19" => :build
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