class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.14.0.tar.gz"
  sha256 "8e1759a166c834d6848f82f6c160fcec17fabff7a1e9deb9435a9491a8ba5753"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "011c3fa345a12e9349d031794f89dd59ba92f21bd7fb58b2bf2d9ae57511fd93"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c2093cb0ef0891bfa5b4774ab7404863325838760ef7bb6a6a3e0437e46d7406"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f7b17078e980a52006eedc8121270e816557bd4a7bf76e1dda7c867a902861c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b9e95f85c8047a0016bbdc301ed8ca4aa9f9980d80a49baf4c7d69de52984ed4"
    sha256 cellar: :any,                 x86_64_linux:      "90b7f04ea07c039eb29f1444a1273c47a144b3fea916913682672560badec936"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end