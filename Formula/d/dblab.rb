class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "42d2f34330b85c84d87190da624f26a7885a83100b6b9da343201e93b17b0185"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ab37e721ab9986f749e7e0311b5ce767c0ade76dbb9bac2530c3acd935db4af"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ab37e721ab9986f749e7e0311b5ce767c0ade76dbb9bac2530c3acd935db4af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ab37e721ab9986f749e7e0311b5ce767c0ade76dbb9bac2530c3acd935db4af"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f3985eec1156a6ad291ad73eae6ae70904d35a70ab7cd8aba651bb3fb4c8ec7a"
    sha256 cellar: :any,                 x86_64_linux:      "a9187853e05eb260abb8648d1a4ca4731218eb7d841a288c1a5def8d31312cae"
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