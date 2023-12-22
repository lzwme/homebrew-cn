class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https:ooni.org"
  url "https:github.comooniprobe-cliarchiverefstagsv3.20.1.tar.gz"
  sha256 "a62242eddd014c347935b3bbface9a0343458a2f8424fa29b1ad927135c732dd"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "627a72558f5e273bc3860a9bd51360c8eba90b349fb22dd585f5593d61c9e4fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65d462ea847c0edea7667daf425f7e55352f0d540c07f72e05bf041a1bc75719"
    sha256 cellar: :any_skip_relocation, ventura:        "6e8a2a548ea7155695aeb2854c72e9f4a3c83d77708e4640f5131c60f46d02d5"
    sha256 cellar: :any_skip_relocation, monterey:       "c9ad268c7fc38abf83e99cf2a9c439d03b980d69c8cb56e2d257cc12c0eaac4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31affd229a7f14a637c0975e7528e3230574d3f84b19e2a3006b69fc80695bbb"
  end

  depends_on "go" => :build
  depends_on "tor"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdooniprobe"
    (var"ooniprobe").mkpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ooniprobe version")

    # failed to sufficiently increase receive buffer size (was: 208 kiB, wanted: 2048 kiB, got: 416 kiB).
    return if OS.linux?

    (testpath"config.json").write <<~EOS
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

    mkdir_p "#{testpath}ooni_home"
    ENV["OONI_HOME"] = "#{testpath}ooni_home"
    Open3.popen3(bin"ooniprobe", "--config", testpath"config.json", "run", "websites", "--batch") do |_, _, stderr|
      stderr.to_a.each do |line|
        j_line = JSON.parse(line)
        assert_equal j_line["level"], "info"
      end
    end
  end
end