class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://ghfast.top/https://github.com/shshemi/tabiew/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "6ec0cde2802c66e053a94a2f8c957fcb4cf6f8c161bd3956f4897e3401dabd05"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8417050eae69855ae4f3066d90674b8ae6b10bddbbecc582bb2b48c5f17d8766"
    sha256 cellar: :any, arm64_sequoia: "c5da263bfcda1c4ef2bcc63c23f4c90028ab4e4f6743e0e5eae9d12ee30a5863"
    sha256 cellar: :any, arm64_sonoma:  "de97e21475160301f555e5e97acc755b19732d9e10d7d240118f11acc1f3761f"
    sha256 cellar: :any, arm64_linux:   "2846d40541c94b145186e416233316d5c0b2b21495f9dd0441f68fcc2da3e692"
    sha256 cellar: :any, x86_64_linux:  "8517687827b03ef4d72edf0fe558ca71f41cc415c0e392caa2fcb12c89bd7a37"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  conflicts_with "watcher", because: "both install `tw` binaries"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", *std_cargo_args

    man1.install "target/manual/tabiew.1" => "tw.1"
    bash_completion.install "target/completion/tw.bash" => "tw"
    zsh_completion.install "target/completion/_tw"
    fish_completion.install "target/completion/tw.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tw --version")

    (testpath/"test.csv").write <<~CSV
      time,tide,wait
      1,42,"no man"
      7,11,"you think?"
    CSV

    require "pty"
    require "expect"
    require "io/console"

    PTY.spawn(bin/"tw", testpath/"test.csv") do |r, w, pid|
      r.winsize = [80, 130]
      r.set_encoding("UTF-8")
      refute_nil r.expect(/\e\[6n/, 10), "expected cursor position query"
      w.write "\e[1;1R"
      refute_nil r.expect("you think?", 30), "expected the CSV to render"
      w.write ":Query\r"
      w.write "select wait from test where tide < 40\r"
      refute_nil r.expect("you think?", 10), "expected the query result"
      sleep 1
      w.write ":Quit\r"
      w.close
      r.close
    ensure
      Process.kill "KILL", pid
      Process.wait pid
    end
  end
end