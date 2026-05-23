class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.4.tar.gz"
  sha256 "09d2561c231b6956b99828a74b3cfbf8f65aca99d627aa0445ce13214d5240de"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb771e5b0d974d7a504603f8e87725d552dc93a90a5b5775d02498e9c9be63ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f4e5686eb4ac819d8bf468fe6a6828467a641ef55f27b6ecc72598bf1722d5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae9c5ebeb5780bb1498613294d4776503e5ad276600f69e9364f4d31d0beeb06"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffa64461959aa915772db53eebd3cdc35e37d32fbfea5e9d24124c431e03f2a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "424663144aaa0379c56e5a5ad851435d0bd62a8b1b5e4961a080620e3e19ba31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "320c1ad232207a0692d05b92f4a729d530205b8e9e903d0aa2e8857b9376fc17"
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