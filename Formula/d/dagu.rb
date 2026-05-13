class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.6.9.tar.gz"
  sha256 "ed6f22e0708134272d9c8a14aef59a49e8dfc1840606775f8c8c5d154fcf6579"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4dd90f9875afefe10b3f1b7a677d91791c6f051b30f6304b0f91164e0feaa5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5782dbedd1770dd2c6ca129e4aca8d06d4e42fda443a292b19110535fbbaabc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fe6ca957882eec8a91cf54749adff6bc39aa4cd0559005596bcc25f6f146e0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0871baf37d1dfaefe3237e90f1607dab888106b2db923319ec90769c336709a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcda94dc3221fe4f6e08447d00a2a460b06b4ae637439465fc281f77b9f59f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bff4523b253f1f732073bbd7170748fbb81b7a72b86efa7e3808f7a449abe7d7"
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