class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.github.io/rad/"
  url "https://ghfast.top/https://github.com/amterp/rad/archive/refs/tags/v0.6.25.tar.gz"
  sha256 "56a5447b4acabc8d190bd7bea4eb7746546684375238b2ef94c423c420f0a6b9"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3a58a4b5a374623920130b7a99cc291495c9726655ab2987089348af6cbd885"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39a2aa0707be583b9d07aff7bd8f9db8ee714165d287cec8db9922f5684e93ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e95b348d5e2793cdfc21e3f69598ae9f2727b4494c518d7262b836ea791a296"
    sha256 cellar: :any_skip_relocation, sonoma:        "3255931decea4013300285b52037e288de7c4d04e0e5cc530da552976b4f0e97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ee18e8b822f5e7ee3a76ce80b9e14eeb5e931984b08f1bc108c4ada12820e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af380d96502109f2497bc0a33499c8f6ba0d7c2d03e2a229edce20067fe17762"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rad --version")

    (testpath/"test").write <<~SHELL
      #!/usr/bin/env rad

      args:
          times int = 1

      for _ in range(times):
          print("Hello, Homebrew!")
    SHELL
    chmod "+x", testpath/"test"

    assert_match "Hello, Homebrew!\nHello, Homebrew!", shell_output("#{testpath}/test 2")
  end
end