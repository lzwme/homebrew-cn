class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.52.1.tar.gz"
  sha256 "cb6c5a0cebe5bcdb791988f499f11fb740b0397a0894131847b72540b774d21d"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c96e06bde901267c9d7f51b7f7d628ef584a854afa661742a1c59118d2167d6b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c96e06bde901267c9d7f51b7f7d628ef584a854afa661742a1c59118d2167d6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c96e06bde901267c9d7f51b7f7d628ef584a854afa661742a1c59118d2167d6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f311f8d8f19a5876a94119149a07a0ddd99b2c02f792108f162fe80215740ee3"
    sha256 cellar: :any,                 x86_64_linux:      "b9e4a564a36058b6f467aa8246c11b6e28617e53a33f7ec506e6cb7c617d2770"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end