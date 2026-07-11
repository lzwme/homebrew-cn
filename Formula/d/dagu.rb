class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.10.5.tar.gz"
  sha256 "4e83d5c212f89fcfb01d4eebfb45135c120c632f39999ed90ebee5c29532bf2b"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c6ac1465ee9cf5c94be52b95010d45ff18d7e38fe26609eec8f07a30c5d8e90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac4f300ebab878e9e06ba0c9e9ad754d606ef91c3e6ea85661eb591d0fb97465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46908b4692885ef30194c09904ce0a8d2a2e705270b16d862ae3fafe4f5b72d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e14da6d93dc78fb4055c7ff81760dfd224e42503337ca57fd9fdbb7027fee8e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea94ff9dc1d38cd6492aaa5f58c7aa9027762b309e3ed001c00bd4a127dcfe71"
    sha256 cellar: :any,                 x86_64_linux:  "22ec49bf7ec73069ad5f72c7b3ff78035f841be616190874c9093b9598295423"
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