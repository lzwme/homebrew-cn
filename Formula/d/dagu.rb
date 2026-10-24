class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.22.2.tar.gz"
  sha256 "faf14c5bf618e9bc11d4e6c20c5fe0230d5f0dcff8680b9d3992f404a967d395"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f5a698a4206e22252410fb1f004accf47b221a28f2041f7f92f36614b65efbce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b28bb63eed9282a9e4a97963be489d5784b8436577eda08859ba6892b7f269da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "11f48e9a6c98a1960050308613ffb3d09f6bf81c6d87fc79ec04141bc346d175"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6f45bb3827b9659bbb84f32088448eacaeb298ff6e4b969f3f04a037f63d358e"
    sha256 cellar: :any,                 x86_64_linux:      "6707d5f63fadc98b478678d9eecebfa02b3ece5e399d34dbc5adabaac17d4d04"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  allow_network_access! :test

  def fetch
    system "pnpm", "with", "current", "--dir", "ui", "fetch", "--ignore-scripts"
    system "go", "mod", "download"
  end

  def install
    system "pnpm", "--offline", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd"
    generate_completions_from_executable(bin/"dagu", shell_parameter_format: :cobra)
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
    assert_match "Result: Succeeded", shell_output
  end
end