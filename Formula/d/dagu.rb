class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "74653eb29aaaa45a555f416bef0caaa80c59cf9bb7ee82a1081d75641c3f252b"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63c476405499c218ceac6853b51b1c8a91764ad32aa77ddb706cd2300eaaaf01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "558f9a26fd99c859f4177066cbd31306f5e2f59c04ce430098b30eb7156cd3b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "967ee6d8e9465d9ed4db81e6adb4f60242a3ee1b1baab7fa9956529b575f3366"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c78b886549de809bb2d643d7d38e4f7d39df46ae45ef63c004c2d77e1eac3a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "458e17a3f4b8fe9dc6efc225206dc564095e432905bad9b517bb413ffc111085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b99df96817cb6c03e1225214855c077c44ad4fe982f7365bc10c1682e077af7f"
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