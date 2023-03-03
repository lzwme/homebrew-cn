class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://ghproxy.com/https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "71953dede2e95f8e3d6bda388d4d613af309702e824994593fca4ad6f8c05d57"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83b35b71d7f0887fe9e9b363950bcd0548e04883de7112c44527ee57366e8428"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83b35b71d7f0887fe9e9b363950bcd0548e04883de7112c44527ee57366e8428"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83b35b71d7f0887fe9e9b363950bcd0548e04883de7112c44527ee57366e8428"
    sha256 cellar: :any_skip_relocation, ventura:        "12d034175cabfc18a94f39be6f3969b66c3b74e81ee9142bcb0d21d3f18e7de2"
    sha256 cellar: :any_skip_relocation, monterey:       "12d034175cabfc18a94f39be6f3969b66c3b74e81ee9142bcb0d21d3f18e7de2"
    sha256 cellar: :any_skip_relocation, big_sur:        "12d034175cabfc18a94f39be6f3969b66c3b74e81ee9142bcb0d21d3f18e7de2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e0505ead0399a3a2d644fbb852ebe4b532bf7a3d09146c38f8f737cfead9e48"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/modern"
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_equal "sqlcmd: #{version}", shell_output("#{bin}/sqlcmd --version").chomp
  end
end