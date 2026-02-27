class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://ghfast.top/https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.12.0.tar.gz"
  sha256 "35cdf137bb420e0c494c2776a3816f7de6301ff581c22d2379845dd087370fee"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff823af4ce71c5ea36aadd99b7b244d16f17dd25646d48d62ed97580e4b8c7cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e62ba66c923e70b9d21199e26cf67749a15c0d7aa754636502ee3cea102df666"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "982b34d14d6236b83a91cac438efafa3317cc38c500eb04e2d26de477fa474e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "22caf5134aa9c53b6fdcdd33bf672d2319b51daf02a64566b6303332aab076b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e29230f616dff0f55385faa9fe71afa6450b09a0a2b5ddcb8545efd02b8fdf4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b329c88b5a825ba124fec8789dd54a6805561f4c95b00f6d33123075b9208584"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", shell_parameter_format: :cobra)
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end