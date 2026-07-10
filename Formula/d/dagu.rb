class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.10.4.tar.gz"
  sha256 "d17101646bd1ba736d0df488c73d9b0be35766abc1f436994fa9fb1d81770804"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19c5c26695bb43644462d4d9a8c585785c8f8a8deb232ce89059a19e11c53b97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "978834e22b436fa39b380076a89c33e2b4a21ba1dbdaf11c3287ccf748a019ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "082eff043a951eff47eb599e55f2d37e88766e5e8a8b0598eaac2fee9956bdc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7530d5b6fbbda3088516958928459db6168aa3e3791693bd44acfdc9758c89d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75b5640f040569d4ddc88353d5621e508a01704cb0bb3f45f5da1e9eb729339f"
    sha256 cellar: :any,                 x86_64_linux:  "4409be41fad87c2c7e1d64960475ba3ac05d9d5a07459358426d2cc6dcb8f2a2"
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