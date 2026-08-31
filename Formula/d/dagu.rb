class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "07881bfb3cde1b8d22b160c18838672e662b0801b350ea76ca31473cbfb6a733"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19a891975869c95d9a9a3ea453d77c00693269cc20a133d4a6662a5ec5b10c7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e5508a4c3261a08fa054b6ef07c7c2b3b7a7457f58568cfabc6583eb24356ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9440f2375df75ec8d3ec3c6038651ba12495feeb0cc967bd5caa4c70366b9f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c73ddb77dd7654d4f06519b9dbd6cfafc18b9e90c5763ed92949f740b4c6954"
    sha256 cellar: :any,                 x86_64_linux:  "023521351a340c3f5f1a05c9df9c58e3aae70f259c3b986868d3b13c97b39094"
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