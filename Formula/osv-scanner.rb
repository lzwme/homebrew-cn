class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://ghproxy.com/https://github.com/google/osv-scanner/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "b2cb5a607a6764fb5c2fd33fad298dffa9743baab615069557f95541d20bf6d6"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8608066ad1152fcf78df76a0a8c6f03d6c34dbceccbe08a700781eb42bceb349"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe7260770e0d15acee9fba1442f2aae9e8fece5988ee8732e99307865c0de5c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9dac6bdbb90707059a4bbcfbee5c6a47169fe815a8eb49726803db8299e9d85"
    sha256 cellar: :any_skip_relocation, ventura:        "3c8d7140d64aedf160dffde126fb0c6a3718435dde228e8c85a0f29fcdbc1610"
    sha256 cellar: :any_skip_relocation, monterey:       "d7d0cfe98ae39df42b357e04893da33b505786084e1e658761b7319f3feabe5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d9cbda18d5433595baced117ba60a90c1f94b4eedeca43c0b9dbc2551777a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26fe253f8663bc8b299a1c3e4005f7315b545b0a2630a941506b5b3654b1b2d7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~EOS
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    EOS

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod").strip
    assert_equal "Scanned #{testpath}/go.mod file and found 1 packages", scan_output
  end
end