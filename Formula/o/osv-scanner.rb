class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://ghfast.top/https://github.com/google/osv-scanner/archive/refs/tags/v2.3.7.tar.gz"
  sha256 "1434f62c3a87caec878ec0af1ddcce3ca00a7f08cbbc06baf2c29227dee5ae06"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c28e966b0c4fe593947ec50350662e90d32c6caae529daf5e26b296d352506ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53b38f8a0cb23b6f7de141795e8210d3c3b68336ddc2ad429b05bfae774b1ce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d810f9f6714870c1f2836c5fcdd35d908dfcbdb358c167edb58d1548688100bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3698b9c538d68ad7debd4975f1535af320ecac0efb580b5f5f047b00fd6f9f55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0cbbafa887e4dae2b95206c5296fc9072247faf88df158e28a10db89f5f2e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97f307206096bbaca8f4b4ac60243ec91615fdc4761ef5cc031a972ce861ec4a"
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

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod")
    assert_match "Scanned #{testpath}/go.mod file and found 1 package", scan_output
  end
end