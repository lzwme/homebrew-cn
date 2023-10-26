class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://ghproxy.com/https://github.com/google/osv-scanner/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "e4aeee5b780cc655ba7766f37217586776122b5b16f64adacadc081dd7d31839"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1585fa7346a8688dddd886c529d5bddee6ecab2fc959fa5894c64b90514d5218"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "038f27ddba0b4e716da23f3e95fee61f32f2ab0a8c1f04fc6f4b527ab055efd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0766438e3a9181d423f36eb62d7cb1d4e6c085080a2e6bdf4ac94b8918566f9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c46dd83dd6542b9f2da0d83047afc8e5e88a8e1d7272c460e66df8fe13093681"
    sha256 cellar: :any_skip_relocation, ventura:        "b08c36a4d08a9ff90307b287a9b1f76aa7ff0b64452322b9c6c6b576349a1a94"
    sha256 cellar: :any_skip_relocation, monterey:       "fc847f544787f129bd044911e6b486564331cce09c73f6ff5b81c1b85851185e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b0df22d4ed95686515121dcdfd9da25149f52948d04c5b30ae808e5fd908491"
  end

  depends_on "go" => [:build, :test]

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
      Scanned #{testpath}/go.mod file and found 2 packages
      No vulnerabilities found
    EOS
    assert_equal expected_output, scan_output
  end
end