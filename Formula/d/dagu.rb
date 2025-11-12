class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.24.5.tar.gz"
  sha256 "4bd3af334bd1ad0f8eb16c914b9f29278f70e926a8e0378a3d55f243768b7b6a"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36ba1975e0288bf05e98835293d192a9be853de30c8dcfb463675a3103c0fc8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a06b2b1d548c3a361a8e58bd8eba05f2b071553cbca51fb609efb69bf5dce8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69b19dfba6c26d53fa6cde3703cf11d066856a7be71feb4ddb4c5307df8427ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "47a267d17460004ddabf98b40f267ef19e820f16baa21142714e96ba8b17b1d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17abe4576ea04427ed81913e3be58a1b079505121ed9e911eed5696b46c38df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c9b1cd2e01f2aa26087a7a31f11a7f226c7e2f1d29f5bb742eacd66faffaf51"
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
    assert_match "The DAG completed successfully", shell_output
  end
end