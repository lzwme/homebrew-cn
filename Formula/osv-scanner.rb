class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://ghproxy.com/https://github.com/google/osv-scanner/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "cc058ea2a51435c0289ca026219439f643e8ef984fe60e87628cdfe519973d46"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5532b51f30af876459a4c9996bcb1d057e349f89131dec58fd45d02e89be77a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5532b51f30af876459a4c9996bcb1d057e349f89131dec58fd45d02e89be77a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5532b51f30af876459a4c9996bcb1d057e349f89131dec58fd45d02e89be77a7"
    sha256 cellar: :any_skip_relocation, ventura:        "4c3c9f1046ab19d02ce7eb620f114b04685c226a5ad2603fe61a8a45c55db26d"
    sha256 cellar: :any_skip_relocation, monterey:       "4c3c9f1046ab19d02ce7eb620f114b04685c226a5ad2603fe61a8a45c55db26d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c3c9f1046ab19d02ce7eb620f114b04685c226a5ad2603fe61a8a45c55db26d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c29b3d0db0d5f0a661fca5c240d2359ee44017a72d91f65ed9e2488fab7c1462"
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
    expected_output = <<~EOS.chomp
      Scanned #{testpath}/go.mod file and found 1 packages
      No vulnerabilities found
    EOS
    assert_equal expected_output, scan_output
  end
end