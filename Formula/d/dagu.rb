class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "385110caf6f5715e8d590d1d76b48bb30b034ba4b5eb3d52be97730c19d4076a"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f89816d3219038fa89b447647b622139232cee8e1f29c7d936262aa5e122dd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77cc2f78372342eaa04b681477165d89b8710b0ea06502e46ec61541822158b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8500ad24d9c4bbede7790b014e71fe95c0345bedc246e856171a56d343e03e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a9be5f958814022de691418af57bea2ab6e4c6fb9da0dc95f91bdd86d35868c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e32dfc825dd183a74a0d679a3c7724604eda0f1f43409a9fce0d699a56f3921a"
    sha256 cellar: :any,                 x86_64_linux:  "71d63b34e1337d7b1b718bc217c43fba5014bc183c795aacbac12bd849c4be84"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
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