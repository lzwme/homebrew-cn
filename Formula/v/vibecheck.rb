class Vibecheck < Formula
  desc "AI-powered git commit assistant written in Go"
  homepage "https://github.com/rshdhere/vibecheck"
  url "https://ghfast.top/https://github.com/rshdhere/vibecheck/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "b32500fed9776625602b083b25c9fe805883f916257b0c7e136f643936c169e2"
  license "MIT"
  head "https://github.com/rshdhere/vibecheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb80314145aba56290bb93d4ecb674d8a04481c68b4261b1c2b272af3fd25f14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb80314145aba56290bb93d4ecb674d8a04481c68b4261b1c2b272af3fd25f14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb80314145aba56290bb93d4ecb674d8a04481c68b4261b1c2b272af3fd25f14"
    sha256 cellar: :any_skip_relocation, sonoma:        "beef349656851c582710ea1dcd4f3e7abab54945c7d95301387336c131e4e9bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "614af0c87f35708d720e799e23b20faf624a5ac65ede9d765e0692a0291d26e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bbfdbe9e89fcfa4778f755fa530ba165ed022a0b343dabc41544588ba4e4c96"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/rshdhere/vibecheck/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vibecheck", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibecheck --version")
    assert_match "vibecheck self-test OK", shell_output("#{bin}/vibecheck doctor")
  end
end