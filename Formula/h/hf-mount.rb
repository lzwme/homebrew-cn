class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://ghfast.top/https://github.com/huggingface/hf-mount/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "dc83b2cfb054c89ff005bd068fe9c48eb1465b23ec5c5bd0602908c138cba25d"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c560b995ecf87e04d95fd17051b2787209fecc55c75dee832b94664f1dead249"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "897d445a953259422ed4df70af4b1053ae6ab438ced70a0e4e4d06a44ba382a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3b1340ccf9fec130a8420f9a469bab9f45292b5b10d0c302b7dbf931cec941cf"
    sha256 cellar: :any,                 arm64_linux:       "6f0270e1d25c87491fa2a1965d9c750632881a498e55f90199b8c8978163ca71"
    sha256 cellar: :any,                 x86_64_linux:      "1a013531a8e7cd945e6aaeac393ce7fef15b497ff0bccf39da562a20a9a8b8cd"
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