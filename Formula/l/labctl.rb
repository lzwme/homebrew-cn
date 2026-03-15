class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.62.tar.gz"
  sha256 "c166c8d64be18e79acf2739df1231b661e07a9ad3d6513a4f1f440542b0e0dc2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "881ccc06d5be55876d8753d84467c1e3b4540a39b9573acf6ea2baad2f81981c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "881ccc06d5be55876d8753d84467c1e3b4540a39b9573acf6ea2baad2f81981c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "881ccc06d5be55876d8753d84467c1e3b4540a39b9573acf6ea2baad2f81981c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf5415643cc7287b081cb4db15d31e7158b4b78eb4600e51b27163e6640d0863"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1024b17e784454cdb9c4ed7a3b2edd180ff4d14a44d76bf3dd8f943b744a9db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "237ee680225717d5c7adbf9e067e26c229edcaa68f06fd18df83351830e7fe81"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end