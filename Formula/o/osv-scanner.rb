class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https:github.comgoogleosv-scanner"
  url "https:github.comgoogleosv-scannerarchiverefstagsv2.0.3.tar.gz"
  sha256 "83864df449bdd335190e5dd7db8d5e1180991796204a0783cdc756834e937576"
  license "Apache-2.0"
  head "https:github.comgoogleosv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7700bde0533f8519dbf8d8e33f09762af242201abd98e7d3d72da5ac5291913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7700bde0533f8519dbf8d8e33f09762af242201abd98e7d3d72da5ac5291913"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7700bde0533f8519dbf8d8e33f09762af242201abd98e7d3d72da5ac5291913"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d213019a515a4fdee7972c076a6648fb747ddefb1b2a7f2399c058e20ff361e"
    sha256 cellar: :any_skip_relocation, ventura:       "9d213019a515a4fdee7972c076a6648fb747ddefb1b2a7f2399c058e20ff361e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52010343340ba0f19fbf552bf6e2044748cfcc71c78653067a76429ddc2ad526"
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