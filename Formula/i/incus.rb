class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-7.5.1.tar.xz"
  sha256 "93338baa19016b1b406f5c8275306ee20afbaf3e3d4b32ea203ad75583266c6a"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "864f707022778302ef3be6f11746f7aea15e659613c768ed63ab56f349eff2da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "864f707022778302ef3be6f11746f7aea15e659613c768ed63ab56f349eff2da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "864f707022778302ef3be6f11746f7aea15e659613c768ed63ab56f349eff2da"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52a3020376961df04996f04f6eb739b1847eb39fe1b9f9ae6a9f49f8207726ba"
    sha256 cellar: :any,                 x86_64_linux:      "e24f08fbc01dc624b0229a17dbdd204e93e0b460587613ee905d937165b2bad0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/incus"

    generate_completions_from_executable(bin/"incus", shell_parameter_format: :cobra)
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addrs"][0]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end