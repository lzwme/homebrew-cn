class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://ghfast.top/https://github.com/huggingface/hf-mount/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "833ef94e2e2c0bc433ba8630a9f14621efc5c214598d32a4d69674fe2ab9a8ba"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df081d0820e7f696f704ef5920de1584310364be022dce2ab01376aa83e53601"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5853fbc70c09794e58e6ec2abbc8c5e9bbdf6ead77b76c98808e595ca3ed471"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "137eff0785b3c501a8fcaf6fdc83a08bcaf723bf4b54f17b54abac0ec34117cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c24163ed71da7ad8c53ef5bc14f4b7b2f0834749c96530b993855d22b9ccfdf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5526c528215c5ebd98c06c2e38c485a415ad6b4e0548a5c0356d66a3d2331552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8566c86694a2f973aa81e6c3995e2e0ea5c1f8739c4188c9573cd3f882a948c"
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