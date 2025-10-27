class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.23.3.tar.gz"
  sha256 "18e36368290c334aea193ac1df2ec4b0c1dd7f6ed3f5778e3ce521cd3105803d"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa29ebfc2ea4f2745f2ef6906dc8f4ce1de6cd66c1da31bf6d9529a5ab5dad3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aaa8ded80ab0a08e75763b0099e25826976daedf9e09d2f2d335f18f9eb200f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bc5bd2ae09bde6531c597d9004b184fb5a02b29758ae8d39856b9daa6b7b15e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfb133cbb76a9bcc96f512c522b0e4773e7ffffcdb4ff14565dba5c421690db6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbe147f6b5356d7953539ae98187ad47ba606e13de04b5482d23efde941ca644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dd398b5ae421a4229d6a0ca7e07f008af5abb26786bea098759e3cee469cd0e"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
    (buildpath/"internal/frontend/assets").install (buildpath/"ui/dist").children

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