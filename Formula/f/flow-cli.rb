class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.17.3.tar.gz"
  sha256 "9e899209d0e479580b7689d3f40bdf9fa1b67faef3968be6800f39d2fddece24"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4603a2be78ef671396fc071e75a9e6b6b3d6ceecb56404f5a806560ad22e04f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "968efdc2c7d88d11d46e161e27f00eb27560dced5faee526925c785bddc15116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "471b90ac28d1c305adaca9a56ef4fda0bc307b55ad44defe5e57514fbf880b64"
    sha256 cellar: :any_skip_relocation, sonoma:        "88cf590c6a27266ecc89901b1b2251efabde45d8fa12344de261a834f7b9b37d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad4cfcfc8fe01bf5ebd25e77e7bb27527809d42b5da5fb7af0784fc03c486a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d5568d3264c8cbaccdd107a308214aa8d547adcea323001769f3a4a7821e1d"
  end

  depends_on "go@1.25" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flow version")

    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end