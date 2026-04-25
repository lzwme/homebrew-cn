class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://ghfast.top/https://github.com/huggingface/hf-mount/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "10d67843343a731d78cd51579fbb55a0dead1a8f17c379f2552979c06b5c706b"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8540f030ed9ea162c681eb104793ea6fd52ab3a577b272782906d24c1fb8a1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5bc61325092ac812a9df2c111a67e8daa5abd745a0d9d40160864f0444aff22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9c6162bb7cd86d823e8d10f854b60534946e7b7427b4b8726ce79e0a5473649"
    sha256 cellar: :any_skip_relocation, sonoma:        "c512da1fd2914e7f0a1dfc8b8653959e8d3221eff0f30c3d694e7621a8a3d4f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aac553cd2aefc7eb250deb2b05a556c2b1e48e017d0be74258a744c44895b6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9c804083dbafe6fcfa171044816761454f0bd7370033c48b895a14a886393c1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libfuse"
    depends_on "openssl@3"
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