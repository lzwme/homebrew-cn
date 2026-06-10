class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "4896b03f16e54d0bad34b5d80a72572721316f8c8b8d2af5f268bb500ff1426b"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd9cc0b6b591574a4c377ab4e3cb9f9a3f1a6ce423c0ca2cd103ceb5d4934379"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "304006d97a50a9858f5fd870eedd77ab2e3317183e2562bedf9667b48770b337"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efbbcb676f1aa4d41f5ec12e65a27120dc7d9ee2e59613564b900d5285026554"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c2d674ac3cd2b4a5ce53034a2b0d43a20cb466ca346245d6cd06b7c7064f561"
    sha256 cellar: :any,                 arm64_linux:   "d0eae816ceed9426111ce03a0f8687d3969d97427994063117b412a9035b337e"
    sha256 cellar: :any,                 x86_64_linux:  "b6c78bf07f54e38d0632442cd4635dcb2f2524bcbc4de657ca1ae3e590e13aed"
  end

  depends_on "rust" => :build
  depends_on "usage"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    system bin/"pitchfork", "daemons", "add", "brewtest", "--run", "echo brewed", "--ready-output", "brewed"
    config = (testpath/"pitchfork.toml").read
    assert_match 'run = "echo brewed"', config
    assert_match 'ready_output = "brewed"', config
  end
end