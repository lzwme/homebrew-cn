class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://ghfast.top/https://github.com/hatoo/oha/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "8d856e2850efb521c0a1f8efed530eeaeebea34d09c6edc19a42dc5e13b14287"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8315770d6eceb8b72eacf6e9886351146f60dcf22aedbaffd1cd07c0cb01e645"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "597f6b2ab99b4f3babc59012162b446ee2359874774e8829749af4151e4af230"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8259062a1f7c81bc75596a758d19d23de81090fe2f2cce87311dd7aba0158167"
    sha256 cellar: :any,                 arm64_linux:       "c89b24dcbe00a46df02cea31b6dd885d9bc5b9eca825681052652e88df263665"
    sha256 cellar: :any,                 x86_64_linux:      "4de4913aabb8a9a54e7867c22ecbde08ffe92e6a921fd0ee5bb1f0cf413f610c"
  end

  depends_on "cmake" => :build # for aws-lc-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4" # Uses Secure Transport on macOS
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}/oha -n 1 -c 1 --no-tui https://www.google.com")

    assert_match version.to_s, shell_output("#{bin}/oha --version")
  end
end