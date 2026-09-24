class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://ghfast.top/https://github.com/huggingface/hf-mount/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "eb51765d6783b39ced2a7a94c793ca1b5d368919727c961c826ce36d0734d2b2"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0ce85cb8ea34060795fee83256141658928a3f98549d3c39d6b570d021cc5a30"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3f97360bec792025dd19fd049dd9c85053c45cfff4eba1c944b7cd7a69861f8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e61194c4f2c41288ad5de3c307739f0e587310623346f383337cd428c50c81e"
    sha256 cellar: :any,                 arm64_linux:       "da3473c2e1f845de7c854ebb4a02bb611adea514b67a486b6441525d7c4264f6"
    sha256 cellar: :any,                 x86_64_linux:      "c7f001785c7346c291caf7062049260c548aaa4d2932e8277c719226ccfe022a"
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