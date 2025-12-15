class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.github.io/rad/"
  url "https://ghfast.top/https://github.com/amterp/rad/archive/refs/tags/v0.6.24.tar.gz"
  sha256 "ae108f8726fce09a7f22cc0349f6460b5e1fc13616fdf3b642249a1a1a35719a"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07ebf42f3435b869fb2da1f153398a0016f245eee7cc70ab129e60cccda0eb2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91e7e4a021ab2ed7668f6c7742e09410da4c321ac4457783c9ce9ff1bfffba1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0772eacccba73e815f7017df48e65817867e43b872f99e3dbff8da9fd1e3dafc"
    sha256 cellar: :any_skip_relocation, sonoma:        "476b272c0723f9ed6e2e0bbc692ebdeda3bd843a62a8936483fc47cfeb2e4554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49a9c06a8a0867cea29f8543eb5781b185d26a874ca1cca9a3da71edebf773ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f29e48a9db4518e672e45b218e29101eb55331f0a8a25453711178bea324a906"
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