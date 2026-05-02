class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://ghfast.top/https://github.com/sigstore/gitsign/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "22a1bdf2a64a03223a911d61695a9ff08df13a0f629dc3ec0c0f9663cdbd3fab"
  license "Apache-2.0"
  head "https://github.com/sigstore/gitsign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30e08473c04de48c370a5ff5222a1d0582625f2aa304867bc6c4fdc8261ec84b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30e08473c04de48c370a5ff5222a1d0582625f2aa304867bc6c4fdc8261ec84b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30e08473c04de48c370a5ff5222a1d0582625f2aa304867bc6c4fdc8261ec84b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e7003db9424d55c248e3913b04079c2b1b6e32d777136c06d63f72a03261a82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b09bf5484f31732da951f99416ccf74ef339a2443e4904d4695248d22876b86a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6d278969abd9d3028d4055702de3687c05932b60ddc39b14be012eb0027676a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "go", "build", *std_go_args(ldflags:, output: bin/"gitsign-credential-cache"),
      "./cmd/gitsign-credential-cache"

    generate_completions_from_executable(bin/"gitsign", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsign --version")

    system "git", "clone", "https://github.com/sigstore/gitsign.git"
    cd testpath/"gitsign" do
      require "pty"
      stdout, _stdin, _pid = PTY.spawn("#{bin}/gitsign attest")
      assert_match "Generating ephemeral keys...", stdout.readline
    end
  end
end