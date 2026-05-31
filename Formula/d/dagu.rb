class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.5.tar.gz"
  sha256 "65d41ca2afa8b21a3f37732ed65991bc21adda9971143fb85f9d698e5948c59f"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a38abfa826789b5eee6b4565046bbae647adec1fd5e00c1cd9b93e4fdc2339d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f690b72885067291afdd22b673277b730f43bb3417fd6c91dd10d22872ed1fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8fa8ce6a9be8cfee4b9e5e43749699f608cee1b12c0f9dd98ae4b449abc99e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "80ec73281cc5cf2190e183da2798bf75bf481c9550851816c77378bdd8dfc004"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94dbc60a4dbb69b52f59d601110390e98d5b61185bfee616a0a08cba4353897f"
    sha256 cellar: :any,                 x86_64_linux:  "cdeeea81d607ac3aac483cb8fa5d02caab77c2715a3b194ea86ef0d1e0a24d67"
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