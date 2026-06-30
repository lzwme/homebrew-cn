class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://ghfast.top/https://github.com/huggingface/hf-mount/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "c97ff8de88bbf810fe41155728c715773d00076775b43196771da2c9d30dd556"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dd7e0c0a71f350247da9274c785fc3a5dc86d281f5485c8725c01dbdfc8802b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "135854ab094839c8df4408cbf2285bf54d9358e101ad77fdbbbaf1c0c3abf5d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8492b1d2238ac82408694954e3b32c3f626282639d80199581a82bb3fe9544c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "020beac1afd99724396b2158bda5b6f332d5a47538c77b2d0a636b0fd0848480"
    sha256 cellar: :any,                 arm64_linux:   "2516eac2a56f4c1c33a8a6e6b92f5116814f3907fcad8a420b79bd2320edbd00"
    sha256 cellar: :any,                 x86_64_linux:  "06c183f87c380ec6ac3799b211ad55c16183376e2cc11b321b03ee4b09cec0d0"
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