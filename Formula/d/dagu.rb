class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "a31ade9ce3959d4f2c11d34772d75642275ced41b8238a9dc77910cf0742dd0f"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3a04bc066e25b420183e5ba376de8f4bd9f32d4d84175c5b598c4944a0de7b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c95cdf0b00b99b8a3b3b34ebdcfff5b83d87213b3d1965b63e1eff9b00d8742"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62556fcfc36670dbcde6d1999933128d523f25483f2115175a93a558dd290aa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb27889fd88b2690552403bdc95257831ee70070aa37b7689bf6b177c7a52fcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa307abde89275de3411c3a56707b6e3c7242123c7543979f3f846430d034e9a"
    sha256 cellar: :any,                 x86_64_linux:  "87738bb9a4af9220e8cb8b8501bf12b9f2cf55e8e374171f0a72a102bde4b5b8"
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