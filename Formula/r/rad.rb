class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.github.io/rad/"
  url "https://ghfast.top/https://github.com/amterp/rad/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "54e9cbd664d24cbb676d78ca51b13ac475074586c327c77bc7154dfef0edf4e9"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a083e5848f0c5b2d05959483cdafc1cfa0ceb69fe444cf13375bdfc783e9b6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39991c1441e42882af4fa524883706c4552495540e8050599260dbb8e27d2eee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11bbeb38df355a7d539a88426f38fa49a92f1ab31ff141100bd0614ae4cdfb0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ca970fde0ed451f58a1ca1368eeb4bdf572137265999f9a7123dd7c9a9a23e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dedde936f7f84bc24e177455fe48d09e6f52ecedac2bc7a9b3ab8cb2b24c9e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7748d9c4953b76e93ddda8aac58c6832f1786452b2f500bb210a3c386dfd905f"
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