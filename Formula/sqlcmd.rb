class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://ghproxy.com/https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "3bb06d2f5c4a66a4ec7972f94aa6a868b82b53c4542e5db69a634b94551bba96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da59dda0ffdb557b7955c3d8f23591199a82b0ec5700fdc3ef3f9afd65a9a67e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da59dda0ffdb557b7955c3d8f23591199a82b0ec5700fdc3ef3f9afd65a9a67e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da59dda0ffdb557b7955c3d8f23591199a82b0ec5700fdc3ef3f9afd65a9a67e"
    sha256 cellar: :any_skip_relocation, ventura:        "9fb519bff6c9956dd93e3790f5e3083c87069e660ed58ad6a15fc69c4e8dabb4"
    sha256 cellar: :any_skip_relocation, monterey:       "9fb519bff6c9956dd93e3790f5e3083c87069e660ed58ad6a15fc69c4e8dabb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fb519bff6c9956dd93e3790f5e3083c87069e660ed58ad6a15fc69c4e8dabb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b8f66e4caa23909c4c8be23f66f1b3d083600efbb4b7c9e958e4d5c62df3b12"
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