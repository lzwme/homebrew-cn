class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://ghfast.top/https://github.com/amir20/dtop/archive/refs/tags/v0.6.14.tar.gz"
  sha256 "d9612d24008944e66d68b5565a48e2acd1be25b165039dfa6056f45c769781c9"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "177b8961418a197d7615ad82960560ab92e99d29c7e010e3befdb900e90cec23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67e7778271e87aac6a5071d05ee4207da58e3fad1ccf7107619ee7364a5a199a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "299bd9ac197d9e9f0ec9ed9fb9aaf2952c60d3df26f687cc6aa9a0cdb34f5128"
    sha256 cellar: :any_skip_relocation, sonoma:        "770e15df81779619967b8c3475fae85dd74bd1908e992246595a6f28151cd290"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5710c2ab7fc362c53a5e25411d033e0bdf74aa22b5c7a2f54f8820e90d42925e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e69c353c403993daf48150ebc3d4b45198487c74c566bc58a5bd7a07a1505534"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end