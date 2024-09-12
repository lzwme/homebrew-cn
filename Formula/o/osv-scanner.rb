class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https:github.comgoogleosv-scanner"
  url "https:github.comgoogleosv-scannerarchiverefstagsv1.8.5.tar.gz"
  sha256 "27e95d475b26ee195aeea240799b091fd2654faca5336537950fb245f320df85"
  license "Apache-2.0"
  head "https:github.comgoogleosv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "47b6f1ec47f9418d2f4530b83a13409dc52ea2a9092d7c5d9a639b56f2941d7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47b6f1ec47f9418d2f4530b83a13409dc52ea2a9092d7c5d9a639b56f2941d7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47b6f1ec47f9418d2f4530b83a13409dc52ea2a9092d7c5d9a639b56f2941d7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47b6f1ec47f9418d2f4530b83a13409dc52ea2a9092d7c5d9a639b56f2941d7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "72325d1ac50ca26609ef55042f398da39652ba8884a01f34b7fe30240fc48e65"
    sha256 cellar: :any_skip_relocation, ventura:        "72325d1ac50ca26609ef55042f398da39652ba8884a01f34b7fe30240fc48e65"
    sha256 cellar: :any_skip_relocation, monterey:       "72325d1ac50ca26609ef55042f398da39652ba8884a01f34b7fe30240fc48e65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8005eb5860fb0da2785a4f13d6205cfc478a07fb047154154914584d402051fc"
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