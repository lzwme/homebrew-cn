class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://ghfast.top/https://github.com/steveyegge/beads/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "2450a770aecb9a8790f95d50b69574461e3ff99285d7c8159e7be7df91e36265"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c50c368befe7bf5e27c0d45cb2e5ebb28a85dd3f9d545c09b2cdf9884af6d0d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c50c368befe7bf5e27c0d45cb2e5ebb28a85dd3f9d545c09b2cdf9884af6d0d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c50c368befe7bf5e27c0d45cb2e5ebb28a85dd3f9d545c09b2cdf9884af6d0d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "55a06e60797fe8f26852bdfa1eea03d12586c0eaf145783b6ceb61bc5a488059"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "310ff06438ddcf97ced3b091cef5d550b9e6d911f9b6176093cec90be62898b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f68ba5ff972f0560de20a963e5f59e528f691364f9b772acb1d6dbb0fcdaf3c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/bd"
    bin.install_symlink "beads" => "bd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system "git", "init"

    system bin/"bd", "init"
    assert_path_exists testpath/"AGENTS.md"

    output = shell_output("#{bin}/bd info")
    assert_match "Connected: yes", output
  end
end