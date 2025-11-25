class Gonzo < Formula
  desc "Log analysis TUI"
  homepage "https://gonzo.controltheory.com/"
  url "https://ghfast.top/https://github.com/control-theory/gonzo/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "f343be039f589faf4745ea35fab01c89efde49556a2e01f7da9679d39c5552f0"
  license "MIT"
  head "https://github.com/control-theory/gonzo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba129bf123c3fce049c8ba9a63fe78daa4030af349e939b57757c08fa2bf24e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba129bf123c3fce049c8ba9a63fe78daa4030af349e939b57757c08fa2bf24e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba129bf123c3fce049c8ba9a63fe78daa4030af349e939b57757c08fa2bf24e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "489f8e540ec69593bd52ab22a4a2838c3e8697cf74f20532f3b88194f04c92ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7099311ec8eacaa827796758458978e9350ff3d1421d0d729a05922856300d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e1275fc0eb5d94e4a88854a2389b2e655d75c70aa08b37b9a01c8b67cad30f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildTime=#{time.iso8601}
      -X main.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gonzo"

    generate_completions_from_executable(bin/"gonzo", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gonzo --version")

    (testpath/"app.log").write <<~EOS
      2025-09-01T12:00:00Z INFO app started
      2025-09-01T12:01:00Z ERROR failed to connect to db
      2025-09-01T12:02:00Z WARN retrying connection
    EOS
    output = shell_output("#{bin}/gonzo --test-mode -f #{testpath}/app.log")
    assert_match "Test completed successfully", output
  end
end