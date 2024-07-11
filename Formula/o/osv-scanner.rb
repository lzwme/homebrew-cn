class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https:github.comgoogleosv-scanner"
  url "https:github.comgoogleosv-scannerarchiverefstagsv1.8.2.tar.gz"
  sha256 "0edf2381dfe48feaf65c117fa51e5c9231ad8d659d102d14a3481e9b2af42b36"
  license "Apache-2.0"
  head "https:github.comgoogleosv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65ce33d5cdf6137c28079c021cd76a5a86ed1c0b1fb7c4d70f5e776c4a072541"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ef90301001f4bac258a4dddfcc89dbf4d655965b388a57e7808bfb977f2cee8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32c7443ee5a8a6cc640f8b0e92155d45afaaf6069a87ab64df8980584f7dda0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "315be2741a51a471833c43eee9122816c9b3f616e2e4d331659c9b7462bec0b9"
    sha256 cellar: :any_skip_relocation, ventura:        "5bc4ee21f72cd22fe01c33b36509f2244ebb7757c1ceb3bbfe6a15c6ce2572e9"
    sha256 cellar: :any_skip_relocation, monterey:       "283f860dbf1610fd5b9b810ccc9717f64b53fd6481ed82ae30fae0dd2bbe6e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05f9db07f5f3c48fbadde050e873b1cf60afb4c85947943e1b73d17fc0fe45a5"
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