class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.10.tar.gz"
  sha256 "5021bfabb5dae4fbaeedc415a298b658f72e32fff912bd9b1c829987c81a99c3"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffddd193ad6e92e4bc2a42a6bbc9867ce263c76614de34b50a10393be8b29e5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "512d608c828dce18109412e4aa048990d05fd52cd53404d81fa38d8ccbbd12ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3faf26c97ff123355a90ced410efa33d9c033257c96d953f3898e238c61d359"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4beeccd2e5d6d61fd908aaffce98d4a00c102b2720b7be1b8cae8962243491a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efc99421bf136c71fa9ab71f8c959299a910290dc922834dd04618f79efae9eb"
    sha256 cellar: :any,                 x86_64_linux:  "fe1115e33f032862c23919f5437fde09262c1d33f1e33884ea0358ed7197b302"
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