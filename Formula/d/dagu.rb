class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "6b7d14154118818da7e93151cc69edce0fe35328e3b34814e8544d0ce136aea8"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7afdbfdfeccc81e2b341736df5a08d829facb79794f96b52567c1a63a7b6e311"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee72b8bf2c6e8d5375c3d9703c16d75de8a5cf691b22ce2165774acfdf442db7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22dfd3bdd50246add3c76c0b1fd971c08f7987b3846df5fab6b5d2c7001dfbfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "48c4632743836be8f8448b9bc923a77ee5b923835a91cf4dece87e5760e06f39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a8e5aa365bcb226cfe2c10397a6a45db663aa8c1f57ca0a9c8edf3b08f1d17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03329c06b51aeab278481e4023adc45bde40f478fb3f40ff60181fe969c295e7"
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