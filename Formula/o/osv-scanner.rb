class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://ghfast.top/https://github.com/google/osv-scanner/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "db34604f20a14cba7f383977495830020edf2ef296b09effb272c96e38de5687"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "537cda9611a2fcac65592a48e199e7ba92a23675821490d9334e09478da7f09d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e0842d2ab6e9376ab491daebf98a41687c01547ee2795aaa1073683192b6a5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5636eab8afc76959b3faf0affe674b5dadf6cabf5af739e161ef31ca641cb087"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed1a4ccac39b29d585c4213e61ae24732ad8c06af4332447ec4db3934e465eec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "629e7b5a861d1e074cd704ee777f09edc492fe4553511562f1cc74fcc2bd8f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7158d5a448a1b756fa0a16584d7973ab6ccb75c0a9a0bc284efa0523836c3dbc"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    GOMOD

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod").strip
    expected_output = <<~EOS.chomp
      Scanned #{testpath}/go.mod file and found 1 package
      No issues found
    EOS
    assert_equal expected_output, scan_output
  end
end