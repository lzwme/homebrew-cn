class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://ghfast.top/https://github.com/huggingface/hf-mount/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "20672120cb96216516344d5db3485a3b0b507b396b087429e3ff91be924df491"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b72c3e556b0948c4f7cce214d2dd6564ab0944b35cdce2f869147846621bf07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f332666f0a422a4c8d8cdd1d9196b593734a8134d63f015c8836561d70614e3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfeed5c42950e6383bce52da2d5ce784b96628ffc6c0d564420cea45f8957f18"
    sha256 cellar: :any_skip_relocation, sonoma:        "79ba84f49401c6ec80d6d59ffe02ab78370aa561b13e6a7fa8999786c713ff60"
    sha256 cellar: :any,                 arm64_linux:   "fa477bafef8b848aff0fd8309071c8d648528486c6dbf4769d65551a6d7c23e6"
    sha256 cellar: :any,                 x86_64_linux:  "6dc29902ab4bbb460b21c3ebb8c5f3bb138cb0b93c34d355945c3df23aaeb232"
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