class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "a4589a137363f79e602f086b5304550647ffc1c691a2c77110961eb79ab13f46"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f9a10351d67d192116b7bc29c342a14c20fcda83f26024e2d0d8552284bb370"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c680ecb179b22591c18afc161c8c8f3f2a6cd2675c4bf3b721b22f1029d9551"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a6528ce15b010a6e9b77fd2f0aed69b202d1cf350463ab21a1a0c7e5d44041a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cd200efdaf7af2ecb7f448279f745a0e781213ac8dcad9338a7dd6464130afb"
    sha256 cellar: :any_skip_relocation, ventura:       "ad80f29d91b3dfcad2ae8ea5782dc843be95fabde33ca9e03da4bf1f9acba0ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "095da47ccafc9a8a5367f833574334c2e4b643994f2fbaf6fc265c539cffbefd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=#{version}]
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