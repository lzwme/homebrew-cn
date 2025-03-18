class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https:github.comgoogleosv-scanner"
  url "https:github.comgoogleosv-scannerarchiverefstagsv2.0.0.tar.gz"
  sha256 "c68dcb953800ae2a30bbaaa3c780e587cd5ce735323489cfb870a6927cde5e5d"
  license "Apache-2.0"
  head "https:github.comgoogleosv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07232ee7355115299544be95ca68c944ed1c1f47d38f8e049e8fd6b2d3fa13bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07232ee7355115299544be95ca68c944ed1c1f47d38f8e049e8fd6b2d3fa13bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07232ee7355115299544be95ca68c944ed1c1f47d38f8e049e8fd6b2d3fa13bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8f8e40c5b7efd7134ed271555980c7ee7f6afa0b94a2abb012d86b98d10f25f"
    sha256 cellar: :any_skip_relocation, ventura:       "f8f8e40c5b7efd7134ed271555980c7ee7f6afa0b94a2abb012d86b98d10f25f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6b8b760a21fb336c031c6b8608a5f9077a25959ea6c36c8ccf419b52d89d186"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdosv-scanner"
  end

  test do
    (testpath"go.mod").write <<~GOMOD
      module my-library

      require (
        github.comBurntSushitoml v1.0.0
      )
    GOMOD

    scan_output = shell_output("#{bin}osv-scanner --lockfile #{testpath}go.mod").strip
    expected_output = <<~EOS.chomp
      Scanned #{testpath}go.mod file and found 1 package
      No issues found
    EOS
    assert_equal expected_output, scan_output
  end
end