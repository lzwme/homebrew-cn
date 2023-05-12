class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://ghproxy.com/https://github.com/ooni/probe-cli/archive/v3.17.2.tar.gz"
  sha256 "6de71c56f92e05cfb6661a86415f1fe2a59466b54b680a17a4b83fdf7de7a87d"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a474cbf5067498c623c8fb329175906946ce1367f393efb3febfefce15da9eea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18bb78569f667a6e9dfb1f11395d3804649e71e47205cc2d18ceeca46fd61d72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b05f782bc81a6c1cd88fe3f956ca4b6a5e82fb29c55760576a230e5548e6301"
    sha256 cellar: :any_skip_relocation, ventura:        "3e0952b7852c2d371e879b0f3878850a5d459cc97a34b76af3f65959e9ed9d30"
    sha256 cellar: :any_skip_relocation, monterey:       "d35fd114895a1003a2bee9968f966cab3b5bf4767f6967a122295969be3d21fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1f0f2b9523c357f8d375ddbb8549493f57954c7d6992f436c036ab4af32bcb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9934c14a9dc07d53d31334fa9bf05f08c86b8fccd6d11de7a6780ffdb46ce0b8"
  end

  # Upstream does not support go 1.20 yet and recommends using a specific Go version:
  # https://github.com/ooni/probe-cli#build-instructions
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