class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://ghfast.top/https://github.com/huggingface/hf-mount/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "f0ca44b50051b65a567a48f57d0b184a329e028f93f6f01805ff5943ea06fbc1"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "911448694ed341e2103665771c508715dca356ede2728c8d22c76b378f85a9ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5c20e3561c1028ac5160c2cbe2f96e38650c489d8b96a727461ea8d20b2f0a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ce52d1edb809ad693d51e0e4dc6e375a52d9f26cac500884de745cce5184150"
    sha256 cellar: :any,                 arm64_linux:       "fc07bd10b8ecf23f8cebe707e3ed5c3d4ff3aa1174eb1e85a5a463cfd2abd5b8"
    sha256 cellar: :any,                 x86_64_linux:      "f20a63b6cd941ca82ba2a2e198be4150f08b8deda0f6499fcc0127ece091ee5e"
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