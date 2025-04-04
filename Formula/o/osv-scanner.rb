class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https:github.comgoogleosv-scanner"
  url "https:github.comgoogleosv-scannerarchiverefstagsv2.0.1.tar.gz"
  sha256 "66bba28548a0e841407ef667c2ab13f5219edda3f4d2c9d0054d07b41e9008bf"
  license "Apache-2.0"
  head "https:github.comgoogleosv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6c7881c2c1270f26a2378983a37548c57a76fe12d8be1a4760a4e08d64d8f4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6c7881c2c1270f26a2378983a37548c57a76fe12d8be1a4760a4e08d64d8f4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6c7881c2c1270f26a2378983a37548c57a76fe12d8be1a4760a4e08d64d8f4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a851886acdccec4210254020246bfa2175d62141f068a788d00c1a01b41d4b5"
    sha256 cellar: :any_skip_relocation, ventura:       "4a851886acdccec4210254020246bfa2175d62141f068a788d00c1a01b41d4b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18bd925f8a8b66bb6f0d451399472f3b5b8e391e7591db8b6655780cc9549614"
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