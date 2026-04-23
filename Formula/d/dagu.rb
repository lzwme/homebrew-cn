class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "c0ed2d10762a3dd0f75528f407c12ef50470411a50f6b9e00b9cc6868621bfa8"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8314a22901307033e6cd254b480de2c66f526655a31bd4eee344981f8347c826"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5128a0a6389d1947e2bbca97e38a6a18198c783ae45b53141dda0258b657e075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c13675f87e01803cbf920a9f0b5af626a12d3f689ba7709cb0a053a3c324fae0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7a193295e0845e1e4a0dad324e8b873b9e1af7cca733412433541b4ef4389f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d9762abc17bfb7a466f665946b19edd649f6426259978d5f2ed00a72f8fa6f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37e522e1c52016e7698dae3c187313fa9fc7b93592c777f6d5b67965d7257ea3"
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