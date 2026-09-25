class Parca < Formula
  desc "Continuous profiling for analysis of CPU and memory usage"
  homepage "https://www.parca.dev/"
  url "https://ghfast.top/https://github.com/parca-dev/parca/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "703d518f2ff1c5f583b1ec98944cd02155085784ac051907faed10291d7ab698"
  license "Apache-2.0"
  head "https://github.com/parca-dev/parca.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a80a1dd359b7943fbb36d72349cabb9cf88b38a36d2576e8079a3367707fe07b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "faac3085fc4987a18704df5936cabe21fc1371b93eced1f8cfe4cf93a7d8df1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8622c2130a11ddfbe8ad74b31ff41ebf7dd07bae40e8c3a40b4481f52c76766a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d222d21913dbefa3d3a92d69f0646ad0643a2e75017a63a931d6ce7b37354bf5"
    sha256 cellar: :any,                 x86_64_linux:      "388a08a239642c0781218f3fbe7994f22c36d004fdaaeb17fd41b43a51c9548d"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"

    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/parca"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parca --version")

    # server config, https://ghfast.top/https://raw.githubusercontent.com/parca-dev/parca/cbfa19e032ee51fccd6ca9a5842129faeb27c106/parca.yaml
    (testpath/"parca.yaml").write <<~YAML
      object_storage:
        bucket:
          type: "FILESYSTEM"
          config:
            directory: "./data"
    YAML

    output_log = testpath/"output.log"
    pid = spawn bin/"parca", "--config-path=parca.yaml", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "starting server", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end