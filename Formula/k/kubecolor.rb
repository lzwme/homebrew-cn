class Kubecolor < Formula
  desc "Colorize your kubectl output"
  homepage "https://kubecolor.github.io/"
  url "https://ghfast.top/https://github.com/kubecolor/kubecolor/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "7c56c03e5a72ad8d78a0da317ef6e1b7aa56dd573854e4277f544707e4f85c1f"
  license "MIT"
  head "https://github.com/kubecolor/kubecolor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd003722de77163653b516ad2211e3ce002722dfea195f6af4663dcae1297411"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "047f880ed5a77aa531444fba7011668e0a809120b6c2db4ee2baf0adb7d612b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "047f880ed5a77aa531444fba7011668e0a809120b6c2db4ee2baf0adb7d612b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "047f880ed5a77aa531444fba7011668e0a809120b6c2db4ee2baf0adb7d612b7"
    sha256 cellar: :any_skip_relocation, sonoma:            "85ba0dbfd11497501694537435b603ad3551218704d99859a95d9f9e92d896ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3142ed58b0c4c6470136b681ef72470717af9cd5e76fffc9cf29d07403819c25"
    sha256 cellar: :any,                 x86_64_linux:      "fb07a18e26f80f9e50155d095417f93a04013014e4857e072cdc73065ef5389f"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    ldflags = "-X main.Version=v#{version}"

    system "go", "build", *std_go_args(output: bin/"kubecolor", ldflags:)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kubecolor --kubecolor-version 2>&1")
    # kubecolor should consume the '--plain' flag
    assert_match "get pods -o yaml", shell_output("KUBECTL_COMMAND=echo #{bin}/kubecolor get pods --plain -o yaml")
  end
end