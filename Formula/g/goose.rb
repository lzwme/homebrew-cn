class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https:pressly.github.iogoose"
  url "https:github.compresslygoosearchiverefstagsv3.24.0.tar.gz"
  sha256 "f7dd8dee34a6a5b3797a519f0c9ebf9afe0bd43faf04c94c87b03e41090de954"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "627aa2d90bececacdd13e57dc0d894b91b697419cd85e0fb908e49ca4d1855a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6efdb6b5a27b03185abb52fbd4b3c19fc4950f98b279ffeb5f43079eefcbd1ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "563333ad03ad097ab0a6d100832e86dd4aad63fcdff52c2f5953b7fb20858f75"
    sha256 cellar: :any_skip_relocation, sonoma:        "274870de1021ae2911e10d9acab339f4e22a223fae781c2b7519c3b942be06b9"
    sha256 cellar: :any_skip_relocation, ventura:       "348d46a8f6d306c0d8680cd4809d61130a02c17d90dadf453d94f3d57b7b5ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dcbd5aeed37185d0e367ef64d9c9aaec69c683f22ea756c726204afe8ed3ba2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), ".cmdgoose"
  end

  test do
    output = shell_output("#{bin}goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}goose --version")
  end
end