class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "f5392eda82c747f2bcdf01eb465a437c30f6f4aa5fb709f291a6d3414ddcce01"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8c67d07331d54003e1aa4524a24de63de7e606a4383d154f0aab5d2846bbe47"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8c67d07331d54003e1aa4524a24de63de7e606a4383d154f0aab5d2846bbe47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f8c67d07331d54003e1aa4524a24de63de7e606a4383d154f0aab5d2846bbe47"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "327e1e8a3a8c5f1b69e272b514426f8d1dce96a86f2a981245793c9c34d27214"
    sha256 cellar: :any,                 x86_64_linux:      "10bd43a7642b217c132ac1fe85f2d986dd9f71c9d6d8c770a611901f3c2504bd"
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