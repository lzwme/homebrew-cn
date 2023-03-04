class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://ghproxy.com/https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "87dbd200bd972d62ef4d8bcecac0c9389ace0fcdacf60c8d831fe5f6ff7b1609"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44ae654c8fe13bcaaa65815ce93c993b410baa004c9fb64db5e0b4316fb31959"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44ae654c8fe13bcaaa65815ce93c993b410baa004c9fb64db5e0b4316fb31959"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44ae654c8fe13bcaaa65815ce93c993b410baa004c9fb64db5e0b4316fb31959"
    sha256 cellar: :any_skip_relocation, ventura:        "de3f75fb6798fabcc0518d47d6489abfade49528752e1ffef19c439a17815083"
    sha256 cellar: :any_skip_relocation, monterey:       "de3f75fb6798fabcc0518d47d6489abfade49528752e1ffef19c439a17815083"
    sha256 cellar: :any_skip_relocation, big_sur:        "de3f75fb6798fabcc0518d47d6489abfade49528752e1ffef19c439a17815083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d54dbff26c5e4550a3c2df33f3a1bf8543a0d56f1d900fca9b3b3d9d77d8eceb"
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