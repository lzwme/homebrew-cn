class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "76c83add3310d3de5945adcc7800a92ea71b04e290bd93bcec8ab1adeb154890"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6298dfe84e534b1d7c5a4e54260375a0d93ae2df7da3f4b423cde8808fbdabd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7746ebae09c0332b08c9a8ad2a6c92085376985c451af83e42a30315c56bab2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31126d9eac9c928d1c6ddf575445a808b874f030cc49802b5eaa819c0b459f5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "beffa543bded4f81358d6731aabfd51113e5a2fd227437aab76cda573ac47679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "916ad3a4f59bdd1310433f6b52d3e10a3dd93c14427cf55fc62f0c82948a9fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4feab61b4a27f133a84a18139f488568aea29e461e2f1d6ca303b8977cc039a5"
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