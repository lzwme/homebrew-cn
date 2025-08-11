class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "00423684c65b55d0255fcffc456dd46520c50415bc9c486a2e4ce4f8b22a3e94"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20c1d3cbb6fd5d16a36077aa0824fe9c1eeda310a24d057ae027b1cd108c0996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d7a36254e5f72f1a3e975ead8a96cd184e25f0854da9a36a80d12597e82aa9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7316e65f1fcc297ea5e0097e16f27c14368ea853ea1cd43195ebc50e48086cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6657cf75b3e4eb4c97a31d5e20430e5cb7525cb3bc0beea833ddcc32c5583628"
    sha256 cellar: :any_skip_relocation, ventura:       "bb9775379410d72f60a0c2b73522afe59f96ac1273942d24b0e5e1c184c4b018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e0c3e85d6a7bc6229483c01982a0beb4e7ce517ee1a7fd6462f3eda92c479da"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  service do
    run [opt_bin/"dagu", "start-all"]
    keep_alive true
    error_log_path var/"log/dagu.log"
    log_path var/"log/dagu.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dagu version 2>&1")

    (testpath/"hello.yaml").write <<~YAML
      steps:
        - name: hello
          command: echo "Hello from Dagu!"

        - name: world
          command: echo "Running step 2"
    YAML

    system bin/"dagu", "start", "hello.yaml"
    shell_output = shell_output("#{bin}/dagu status hello.yaml")
    assert_match "The DAG completed successfully", shell_output
  end
end