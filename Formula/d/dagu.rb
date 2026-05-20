class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "5318ea27aa0060b172b743d2233095064c5256677ebea4a10d8af66fb3fb430c"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fbe9f3a51f0fae626f678ef0b7648dfedfecc77b41f1de41d2de793946be9cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1179b4ba0e536b2cbcdbd691876c75684bf301dcc65dcaf72bd092816f74c2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "020c2fcbcd22938e4d664d98cd12f8f91273cb0c58abd22f839fc85ce84227a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "febab4880d5608306ecc335cb556e89327079cd472757f571c2441d1860f813e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f3864b2852b170eebdc134b962b64aa6b1fddc9525c232ddffe73266870c348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61d79524b637262f934ab85f13c06c1fd5f305361dca12318dd21f4af1d68263"
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