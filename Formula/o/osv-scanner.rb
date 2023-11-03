class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://ghproxy.com/https://github.com/google/osv-scanner/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "a32daca1d28374b7f63174467bb72783b3f478aed8d260263aa88056271b7f21"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d98c383f6887cd11bf3497d5d286684897823a43877bd7fff772f8c484972b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "535f90e2bf65c043844aff84992bf832952960d97ac5b14dc97430bc6967be19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ea7bbc00ef170756c958c68744b0cea41cdd8afed614649a3beac168bdc0330"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0f6d950b4ff7b1da95b5b6a484d70e3dc712051604f33e02795174a0f433bfa"
    sha256 cellar: :any_skip_relocation, ventura:        "89fc08dd66487bc3a369d66c3a6bfef449a38f081989368b00e03014e334af6f"
    sha256 cellar: :any_skip_relocation, monterey:       "51a702e870c20f70f9b49935f686f4080fc086bdc14da0593d30a47783236725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1176061ca98ec622d1495f02e7b218143ff092721416cead751120188c60a136"
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