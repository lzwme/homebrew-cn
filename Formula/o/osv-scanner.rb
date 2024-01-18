class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https:github.comgoogleosv-scanner"
  url "https:github.comgoogleosv-scannerarchiverefstagsv1.6.0.tar.gz"
  sha256 "d99fb646e39ffef3eeee58e913bdc5c5a665aed0f374cef099a50da9bd7d1b92"
  license "Apache-2.0"
  head "https:github.comgoogleosv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c54ae5444c5e27c4780bff30dae076240fe8fb9e3cf039ca5fa68aa11115b3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3d911958a73842a592730cce7fe65d16c10f58cc6cc5e54ef450fe0052035bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ca92e16f9d22e5853fd524796c5509340fda60c0f8077f63fe40760b33c7944"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a5a9c424cabe57d4089e2c7349fa5e2f97b7e5a90c73f763c6159742a781ca8"
    sha256 cellar: :any_skip_relocation, ventura:        "53ddba3677815502240ee249cf5c04040a595488d8bbb867e2718cb806b8dd0b"
    sha256 cellar: :any_skip_relocation, monterey:       "5a9894ca3fccfa95a9a8254b13a045de2004326f8ab1f6601a4016825a23c017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f97b940b4a47b981a07caaa674a3f3123fbff5b6705bf8985ad47fcd05e1d373"
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