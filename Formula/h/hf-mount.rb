class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://ghfast.top/https://github.com/huggingface/hf-mount/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "02f2afd447774f7a751edd1a1d5988e430277b0780cc6656ed89f42c5eaa6f0b"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd810b37974147002ee2a81b2fc905735fdcbc5b8cedabc9cdc99066d5376486"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22471f10ce8e8248f0df24a29511f3031cfab8474626b566ed7e73b79cc0b83a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b62281ae00f999330c637d46970243f672d071218126ca96c3af968a570e669"
    sha256 cellar: :any_skip_relocation, sonoma:        "315b3b1888c7fe1821cd999ba38846a65d9bd3f1d0328b1d5f3567106ab3e2bb"
    sha256 cellar: :any,                 arm64_linux:   "c46bf0809821e7bd2b53e602e43fa0f24db766fb109b3b878cdbe7d41bb1e64f"
    sha256 cellar: :any,                 x86_64_linux:  "32d6cf3a2c25e7dee741f4355e2dc83b025a0ed9429613a1d00b3a4f51e24beb"
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