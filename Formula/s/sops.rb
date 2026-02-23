class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://getsops.io/"
  url "https://ghfast.top/https://github.com/getsops/sops/archive/refs/tags/v3.12.1.tar.gz"
  sha256 "90f9cdc55e653f3c40986cb288f50bd44b6277b7d329714f7a2a1bad6bc97074"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5237fb710b59b9b31e4d174b4fc03b6dc0a0f8fc5af1a7e6c957b6d0f28814b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5237fb710b59b9b31e4d174b4fc03b6dc0a0f8fc5af1a7e6c957b6d0f28814b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5237fb710b59b9b31e4d174b4fc03b6dc0a0f8fc5af1a7e6c957b6d0f28814b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a9e45fbfd096881a7a236b3562d4c863e0f7460dde8263d9ce5a16840310943"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b3e9d1e1897116dfd75698674f9c313914ddc573371e9437a62608fa7dba120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c62e7d3201d9c9b54031fd4a0085a8cb422201f669b2686f93341374b5a950f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/getsops/sops/v3/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/sops"
    pkgshare.install "example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end