class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "c3870ad737361b67bab53a60eee30f342c43d7211587824ccf5144f3b3f60a20"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b00d157181cee4b5e5eb3cbd2765808b5ae49ca05e8d48717405611718467b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a20bc79aefbe5405390e18109978a39c87bcf7847751995e895b3b17bbb0590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad54a50512d3dd90fb34beffcaafb38f89b7297f707279bd5b8a6eb15c6ce445"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a4d88e415fbce4abedd49b0b36541ddca1de3e15e87869c12f726848ff32fc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "702f3d8f7ebfe6ccf832a7bcf53ec2db04807b280441d9c24eeafc8485a1725f"
    sha256 cellar: :any,                 x86_64_linux:  "adb7d2756ea64c4881b99e9fbdd5bf9cb0f44e1d6c2d74fa467ff7881c5b089d"
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