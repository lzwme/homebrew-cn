class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https:github.commaxbrunsfeldcounterfeiter"
  url "https:github.commaxbrunsfeldcounterfeiterarchiverefstagsv6.10.0.tar.gz"
  sha256 "ad966cd565108ce4c0d5283199e79e2792a68b28a82227a10823343634e88e53"
  license "MIT"
  head "https:github.commaxbrunsfeldcounterfeiter.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c328ef7ed297c5c6328333b27b793119ee40adcbd9be010f0effd7bc94310d06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c328ef7ed297c5c6328333b27b793119ee40adcbd9be010f0effd7bc94310d06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c328ef7ed297c5c6328333b27b793119ee40adcbd9be010f0effd7bc94310d06"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddaf67b243801ea59a47079a02da8858b98e5391c2574a14d1f57bbf88050311"
    sha256 cellar: :any_skip_relocation, ventura:       "ddaf67b243801ea59a47079a02da8858b98e5391c2574a14d1f57bbf88050311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e080a73cf9249171a3cb8f4363f6fcd1e5fa6135b59180ea3495046823e4cf0"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GOROOT"] = Formula["go"].opt_libexec

    output = shell_output("#{bin}counterfeiter -p os 2>&1")
    assert_predicate testpath"osshim", :exist?
    assert_match "Writing `Os` to `osshimos.go`...", output

    output = shell_output("#{bin}counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end