class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://ghfast.top/https://github.com/huggingface/hf-mount/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "da9d2658bc91aa98ddd52b7169563d9cb1aacc5f779f3db587456ed8a543c594"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63fd535386f08a5e1d4388a9ece1e5466039731e7e2583ea04dca003e7bc2bed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b581ef204a5463245ed7e7e565ec6fd1192672bfd3d5adb26c5cd2ac9baea683"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbd978fcefaeb44d8152c6dbd9a453a510561f4bef643a7a638f5eb9ebc63e7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "03d54ed15a6bda87687b83b8fb78cc57ab39bb6f685ff47831c232a8a1b80e5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24ca9ef1ba29fe60b3fad58859ac8aa49049ba9a6ab0ec61112e3ab81c17845d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d1f5d1c03a14229c3699383808d5aa4f9c3a33c1305b5bb9f656791ac6fe162"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libfuse"
    depends_on "openssl@4"
  end

  def install
    # macOS FUSE needs closed-source macFUSE (not allowed in homebrew/core)
    features = ["nfs"]
    bins = ["hf-mount", "hf-mount-nfs"]
    if OS.linux?
      features << "fuse"
      bins << "hf-mount-fuse"
    end

    bins.each do |bin_name|
      system "cargo", "install", "--no-default-features",
             "--bin", bin_name, *std_cargo_args(features:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hf-mount --version")

    # Daemon registry commands work offline and exercise the PID-file machinery.
    assert_match "No running daemons", shell_output("#{bin}/hf-mount status 2>&1")
    assert_match "no daemon found",
                 shell_output("#{bin}/hf-mount stop #{testpath}/nothing 2>&1", 1)
  end
end