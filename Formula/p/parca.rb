class Parca < Formula
  desc "Continuous profiling for analysis of CPU and memory usage"
  homepage "https://www.parca.dev/"
  url "https://ghfast.top/https://github.com/parca-dev/parca/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "d20f1df3e8be69877abae48908e5725620c765bbdf4de23662945f63ee82be96"
  license "Apache-2.0"
  head "https://github.com/parca-dev/parca.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a3b8a7792429eb8ffa59b4a42a08cbfd3a741faef36c4807d2c48bc220dce7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88bb4a7f0609ae32b32c7a0d7d03a67b476127232a8d52e1a0454a5e75185f12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "068810166649560db36d421626f2c0d43b7b599f185c19145b6586587ae7f061"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0f6389ce118f4a443912feccf71427e833e3d3f4ae47dfff206af5c5f771072"
    sha256 cellar: :any_skip_relocation, ventura:       "80cbb4b0e93b5ee35144dc902f798aa4bf1e1d47ab82f361b51d3565b3f93f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60b95a770439d58b1e604a9b088b365d3d56b8b0ee2b2da371cf2523aa310a98"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir", "ui", "install"
    system "pnpm", "--dir", "ui", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/parca"
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