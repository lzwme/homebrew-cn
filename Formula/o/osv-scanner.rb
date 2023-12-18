class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https:github.comgoogleosv-scanner"
  url "https:github.comgoogleosv-scannerarchiverefstagsv1.5.0.tar.gz"
  sha256 "4de0d5f942270ac57a81d7f1ff42b68e6042be5a1afc5d119f4797952a0197d2"
  license "Apache-2.0"
  head "https:github.comgoogleosv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33a68970b8596bd120bc06f34358fded843c6e1028edfb9e948dbb59ed1e1193"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee76215ea31354e9e3fd9995cf9175aab9915a196af91421aae61c5093f6d937"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f62849584a9dbe6e5177a175f983d0e484e218ba66dcf39f610402f419da779"
    sha256 cellar: :any_skip_relocation, sonoma:         "78569ecc5ced576c3fd993e5959ea85e4aecb15a0c944266317248c95940d6b8"
    sha256 cellar: :any_skip_relocation, ventura:        "841d34b7796512785b1bf1e63be59fec9cf7f2312457bb96467d8b918d3c3ffc"
    sha256 cellar: :any_skip_relocation, monterey:       "f2ae5cb436867610c3df0421fdca9159b0758700c2d9e2e146da03b5f1cc9256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bcb303639ffcc9fa4c51f5e55672a5b08b48786c256d49abdeb0feddbdb17e4"
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
      Scanned #{testpath}go.mod file and found 2 packages
      No issues found
    EOS
    assert_equal expected_output, scan_output
  end
end