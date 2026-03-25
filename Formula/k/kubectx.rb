class Kubectx < Formula
  desc "Tool that can switch between kubectl contexts easily and create aliases"
  homepage "https://github.com/ahmetb/kubectx"
  url "https://ghfast.top/https://github.com/ahmetb/kubectx/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "b6c5f73eba17293cc860a7f46080bda43a547ba0ccbee63595476afa7b2b17eb"
  license "Apache-2.0"
  head "https://github.com/ahmetb/kubectx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef8f0ff3b3f0b9f45e1176f6ffeef9675f2aa75efec15e0b9d04cb0761f490eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef8f0ff3b3f0b9f45e1176f6ffeef9675f2aa75efec15e0b9d04cb0761f490eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef8f0ff3b3f0b9f45e1176f6ffeef9675f2aa75efec15e0b9d04cb0761f490eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "80ba34da02333894823c0a26657ef0bc5289d6c69793d66d2e380931eef2ee60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e20ab39c84c9ea6b20d819f6e55fdca8a51412056b4a52af114f4175099c1f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c05227285fc0590d808890bb2e57937bd1a4b6b1e0e58542632c7a4da401f585"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectx"), "./cmd/kubectx"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kubens"), "./cmd/kubens"

    ln_s bin/"kubectx", bin/"kubectl-ctx"
    ln_s bin/"kubens", bin/"kubectl-ns"

    %w[kubectx kubens].each do |cmd|
      bash_completion.install "completion/#{cmd}.bash" => cmd.to_s
      zsh_completion.install "completion/_#{cmd}.zsh" => "_#{cmd}"
      fish_completion.install "completion/#{cmd}.fish"
    end
  end

  test do
    assert_match "USAGE:", shell_output("#{bin}/kubectx -h 2>&1")
    assert_match "USAGE:", shell_output("#{bin}/kubens -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/kubectx -V")
    assert_match version.to_s, shell_output("#{bin}/kubens -V")
  end
end