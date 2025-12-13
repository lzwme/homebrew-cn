class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://ghfast.top/https://github.com/PRQL/prql/archive/refs/tags/0.13.8.tar.gz"
  sha256 "68fb0ee26239de7b63da3af60a63f01dee290b433e52a2805d28735700ad6b3d"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "debc7f8f2e488c863ab42789a9c4f499cca780d5bf9a365834466cd67be0c95a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a592a4fdcb087510b2c3be655c2b966f34300631efa901e7870a1b0a32f8329"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c032d84720a635c3ba4827fe5ca9dc5ff92161140c1ef6eadcece6d12a2526ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b135b2fa5517a6d9fbfe2c73c2e1bc062aa917aec112055284f97bdaa2c3e91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27475181dec7a05006b11cf98e53b1c9ae9fe616a220028225420e645608d91b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56d0d5c872453489388e6376cc6189ce419b7cf09ec7f9fb6f224b6613daf021"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")

    generate_completions_from_executable(bin/"prqlc", "shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prqlc --version")

    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end