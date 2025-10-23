class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.23.2.tar.gz"
  sha256 "846abd9dd5b2f386ecd591eb47a6010154669db8c01bf341605657f1030a99e6"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d83ac790b6f3ff81a1dfc8db2e3af9e5642e3162b6a625871a7ab713c1c52e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "606e75d4312e123b0effb68f5ddf5c9fb5983da08d7cd2d2c46919df952d2270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a022d7657e91c41c60b630cdac077074cd692d21f9894e46ac075c5b8c94c5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6815297d6aec16e1db4cd5d800c8e909a386618728c2bc5b6c72625ee18aa588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30b2ddae82c0bc48f3ab26b312070d0befba956180b7163997901842b06e2f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcb4930fda8423ece7cecf260bcd2f7ea89304b77840ca983e050ad9d742c928"
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