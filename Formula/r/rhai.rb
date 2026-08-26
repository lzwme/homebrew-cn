class Rhai < Formula
  desc "Embedded scripting language for Rust"
  homepage "https://rhai.rs/"
  url "https://ghfast.top/https://github.com/rhaiscript/rhai/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "8e9837c5910af447e4d3c700491db1dec02eea562561ff3b4cb0642ef11b5b29"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rhaiscript/rhai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c433b3a1c315f30e23c73c0659dc24865c225185e38aa94686599ea0b650e0db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7102a6b6a4b2969d8e30d856187f20c29c57b5cb3c3ff7106d96b2df44f5549c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd680fed8acb2cbf5cdd9458b57851d41dd640c059173b34636d4a2333251e42"
    sha256 cellar: :any_skip_relocation, sonoma:        "61f662ab0de8e1c2e1a3adfac9cf85ce8dd6498132bbfd973ca2a3427dc9f65d"
    sha256 cellar: :any,                 arm64_linux:   "324af3848b62b018b7b459c420444b4fe91e0b66fdb6039fc02c4ab08c9b2aa1"
    sha256 cellar: :any,                 x86_64_linux:  "4be8f2ba0d40fd516be875f2ca0ed2183dfa5419894c3a7f834f7b9f3fee6286"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"hello.rhai").write <<~RHAI
      print("Hello world!");
    RHAI

    (testpath/"fib.rhai").write <<~RHAI
      const TARGET = 28;
      const REPEAT = 5;
      const ANSWER = 317_811;

      fn fib(n) {
        if n < 2 {
            n
        } else {
          fib(n-1) + fib(n-2)
        }
      }

      let result;

      for n in 0..REPEAT {
          result = fib(TARGET);
      }

      print(`Fibonacci number #${TARGET} = ${result}`);

      if result != ANSWER {
          print(`The answer is WRONG! Should be ${ANSWER}!`);
      }
    RHAI

    assert_match "Hello world!", shell_output("#{bin}/rhai-run hello.rhai").chomp
    assert_match "Fibonacci number #28 = 317811", shell_output("#{bin}/rhai-run fib.rhai").chomp
  end
end