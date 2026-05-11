class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.6.8.tar.gz"
  sha256 "6de8d196c774fe2fcf51ab78376c5afd97745d9737ae7554d3f8b811d7b297d7"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "494bc05f6df5d6a2744f2e68a6e347770ea0fcd5120824da9681309098403da5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f4d58068060c65ea62fd833cfe2e5505556a83d8ca247e0d0e511f2f4cd6e4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d61f10ffd16e9cd808504ff9e3b2660dae4bb00c2c9296690268b803a07b94fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "79931d5c2c5976de32aa340b7414dc502c0c69af66fd27990e1e0c57999767ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eb84cb11359e1450bcabc888103fc1de3ea14fe4dd486620e15fd15026fc447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c00cb29b8933da2552778e9d2424ced13edcd05bf9909e2908772b7daf592f7c"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
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