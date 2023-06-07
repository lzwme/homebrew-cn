class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://ghproxy.com/https://github.com/ooni/probe-cli/archive/v3.17.4.tar.gz"
  sha256 "2da54ec825351a3b4390e6f813a2d83775e638c724247befa0e76fe278d9dc66"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fb189ac5e7f1cf0b906aa580b443d503cf48aee31f835031f32ebbc07bab1c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcb4362397c6b6a674d416af40165102d4ccb01aebb8fd178282160d4e1065c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3e3c3239b83a4373db54a61556ab79adcbf2379968bd8c61f278211cf4c8b6a"
    sha256 cellar: :any_skip_relocation, ventura:        "191605dd34642ec1d266d15c5448adce01c69acc65dae0e39944d0f4ed6ca320"
    sha256 cellar: :any_skip_relocation, monterey:       "afaa133c38d3d37b075ac43a6607a70567c8fecc1c62d67e0c4ab661e78c6800"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9cb58d6ed67ed8c76db0a517ebabb29d57ec55544ee4913e7e2af7ca7714414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ce07685bfeae450891ff87350dd2a276a78db22314ffc940c62112499578b76"
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