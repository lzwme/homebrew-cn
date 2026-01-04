class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://ghfast.top/https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "9f714b3d35fa7cae5a2193cf11a2e9bc97bd0a9bbf52ccaea432765bf8f63f3c"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfc4077a67d0c13f5e7887031085ed6edd24b6940d2d372a9fa82f15a5377335"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfc4077a67d0c13f5e7887031085ed6edd24b6940d2d372a9fa82f15a5377335"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfc4077a67d0c13f5e7887031085ed6edd24b6940d2d372a9fa82f15a5377335"
    sha256 cellar: :any_skip_relocation, sonoma:        "5726cca0b98ba4e4ede5176e15e2606579d7f29cc26ac95ddf17aee1c9ac1e9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f457f342181670bf32cf93f514e3ba10bbcacba4080246c5dc6b3904d295b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d88c9935410b91ab7d98cdb29836423f2e5698ca4c90fdfcf4acc3a73a22cce"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end