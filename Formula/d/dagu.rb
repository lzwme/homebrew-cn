class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.15.3.tar.gz"
  sha256 "5576e758da945c917e497d551e48e26cbd7643c1384e2703080fe409d2372395"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c586d1017395ba122ab931e88990975509b674bb4a85af4fdf7648d2367a726b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1877f6e26cdff915e6fb5b6af7c846c3c2af51ee8d24d5d667baf734b0a41ba0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "506d45e4d6d6a270c78255cafb5acbfc344be5f271e8d477b9bd95ee4f067b2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b157a284e66ce780535731bbcdd1a5030bf18561ae9a2e36d145d59bd5d84182"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9880f7333287e7a53ab4cf35e1c47f5ef5afdf5021d4d18735d8303bc359bda"
    sha256 cellar: :any,                 x86_64_linux:  "fcbfc007ae388e53290398c1b2f219b2d32932fd27be2159ce82a6e9c9f21259"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd"
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