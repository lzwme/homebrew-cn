class Iamb < Formula
  desc "Matrix client for Vim addicts"
  homepage "https://iamb.chat"
  url "https://ghfast.top/https://github.com/ulyssa/iamb/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "a5cf4f248e0893b5657c5ad1234207c09968018c5462d4063c096f0db459dd7c"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9b2816b58b70c40d08ae0a833832c1c4345bf823d46e3196c9a3bd5ca87b54e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c7cf13429008136a40891a4ffba81362151dfa49ae2a0608825789e622c8bbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d38e10f00f46531f88522a5a38476a786a3a0aa31ae9905e3cde499f63a53725"
    sha256 cellar: :any,                 arm64_linux:       "be61c0d7e3136b84ab37a58bdd3540c771fa53842d89698c075ff6bb9cd2d143"
    sha256 cellar: :any,                 x86_64_linux:      "cefc25f3cf0111dc172f3fbd5ca78f383727e2e664a62b5032a5448f763efcff"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite", since: :ventura # requires sqlite3_error_offset

  on_linux do
    depends_on "openssl@3"
  end

  # Rust 1.94+ overflows the default recursion limit on matrix-sdk futures
  patch do
    url "https://github.com/ulyssa/iamb/commit/d69bc64cb9f6ddd150d5a6f1e08119f4cc74740e.patch?full_index=1"
    sha256 "c7f804a296abe18828d26884098a6755bd633705f4703648b0154bca74c29f4a"
    type :backport
    resolves "https://github.com/ulyssa/iamb/pull/599"
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Please create a configuration file", shell_output(bin/"iamb", 2)
  end
end