class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://ghfast.top/https://github.com/google/osv-scanner/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "cb89726b83727eabd3a640e3225e0361330f3a8e01a3a165d47345c883d110a8"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5edbcf5014e8538fba3df2ea2e1b083d0cce697f48de0d53c7cee7a1050ec9ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac1cc73e3c925ac1145a2599f11899d1fc43050af5d7796c7584b610bac73af3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dde0189748a9a5e12f1ff3975676dc7eecaeadb830d6106ce436b64ebbf0258"
    sha256 cellar: :any_skip_relocation, sonoma:        "49cafbd116aaccf6af8135be7d0c334bde723365da626a21d2cf36e6e1fec07d"
    sha256 cellar: :any_skip_relocation, ventura:       "dad12adae16086f45f955d34014b777580af91529dcfaae2848b25fda8972b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a241d9948c8c6001cbd9c39b56182e9f534b0373de73f6391a2fb0a0cbad4eca"
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