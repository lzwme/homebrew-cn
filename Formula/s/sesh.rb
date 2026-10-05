class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://ghfast.top/https://github.com/joshmedeski/sesh/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "0d4f7dbd1889b5862fae56941595f902dcfe03d66d6b07fe6bd4959bee5a7ce5"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f7f2288d369b1e4b35dab54b701334b458fc531845dbad865b35c86c03f76a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f7f2288d369b1e4b35dab54b701334b458fc531845dbad865b35c86c03f76a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f7f2288d369b1e4b35dab54b701334b458fc531845dbad865b35c86c03f76a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "17aeabfa9b20366ec0f6787deb955a1437e90da1950cddaf8bf55dd62371de68"
    sha256 cellar: :any,                 x86_64_linux:      "06d6b0cd536b09518ee7b9ea4bc0237f9a7aa808ee05cfe5df8f3d4f22a7f4fe"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    generate_completions_from_executable(bin/"sesh", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end