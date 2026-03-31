class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.39.tar.gz"
  sha256 "9b70d99e177adf0894a3d8dd88fe2f61ac8ccb43e5a5bebdafd4d7d168e411f7"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbda24656e22d710c80772f11b4f2fa130c44c6fdc954046d61810682755a8fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbda24656e22d710c80772f11b4f2fa130c44c6fdc954046d61810682755a8fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbda24656e22d710c80772f11b4f2fa130c44c6fdc954046d61810682755a8fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "f78341877797e5dab4700ae29a629148f48ceeed55be7976acda973f5b60dab4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be6e94490b98810f5770d01ee064d27f0273a21f99bf1cedc672078b255a62b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "953e312f1eaf3991a4e95aec2a73d406e0cdf3555fdbafe90d31be8d814cf5a1"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bubblewrap" => :no_linkage
    depends_on "socat" => :no_linkage
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
      -X main.gitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fence"

    generate_completions_from_executable(bin/"fence", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fence --version")

    # General functionality cannot be tested in CI due to sandboxing,
    # but we can test that config import works.
    (testpath/".claude/settings.json").write <<~JSON
      {}
    JSON
    system bin/"fence", "import", "--claude", "-o", testpath/".fence.json"
    assert_path_exists testpath/".fence.json"
  end
end