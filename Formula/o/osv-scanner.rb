class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https:github.comgoogleosv-scanner"
  url "https:github.comgoogleosv-scannerarchiverefstagsv1.8.4.tar.gz"
  sha256 "a3882cfe23b8d31b89bc771f112a2c796d5d42b8ec538399ce520216cfdbd835"
  license "Apache-2.0"
  head "https:github.comgoogleosv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dae46ce108603cdb7de6c8e642c5de48ea5761e669223defcaac5502fe3d1b21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dae46ce108603cdb7de6c8e642c5de48ea5761e669223defcaac5502fe3d1b21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dae46ce108603cdb7de6c8e642c5de48ea5761e669223defcaac5502fe3d1b21"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d72892ba99eed0668dacb6993548e0a94ae044858f3c260027dd7ea23ec7d04"
    sha256 cellar: :any_skip_relocation, ventura:        "6d72892ba99eed0668dacb6993548e0a94ae044858f3c260027dd7ea23ec7d04"
    sha256 cellar: :any_skip_relocation, monterey:       "6d72892ba99eed0668dacb6993548e0a94ae044858f3c260027dd7ea23ec7d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9af0d017e19ef7579c7b713080970d15ef11981e600d77c6377951116877a362"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdosv-scanner"
  end

  test do
    (testpath"go.mod").write <<~EOS
      module my-library

      require (
        github.comBurntSushitoml v1.0.0
      )
    EOS

    scan_output = shell_output("#{bin}osv-scanner --lockfile #{testpath}go.mod").strip
    expected_output = <<~EOS.chomp
      Scanned #{testpath}go.mod file and found 1 package
      No issues found
    EOS
    assert_equal expected_output, scan_output
  end
end