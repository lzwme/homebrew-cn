class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.20.tar.xz"
  sha256 "8f45728eefe3fe3e77478ddcac2a0b883adf77bb80f3f786c69177d33b15e7bb"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbe2f76432335da2af6c5f9d2798e2941bfdfb9c085990661f49a0841b0343e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbe2f76432335da2af6c5f9d2798e2941bfdfb9c085990661f49a0841b0343e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbe2f76432335da2af6c5f9d2798e2941bfdfb9c085990661f49a0841b0343e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "65008cd0a138f021f97770f99fe7839331f9fad6b573c9dde138b8a8f809d137"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9a1dcdb6e6d270db0cb32eff3f9c28df2545a1014618ae441b727c8b0767e84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6981e1a78a4861d15a9e5e5abd8445081ec3e439cf3ca5fff48882715ef63d5b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"

    generate_completions_from_executable(bin/"incus", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end