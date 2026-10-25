class Memex < Formula
  desc "Index and search local agent conversation history"
  homepage "https://github.com/nicosuave/memex"
  url "https://ghfast.top/https://github.com/nicosuave/memex/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "df535938af3aff97d1e11c403041b0f150e678defd4c57f25b6ceed8fd528cca"
  license "MIT"
  head "https://github.com/nicosuave/memex.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bd1e4a253f6ff2e4c77547c16fa0dfc0717c20a8af86f878dfcc4d08addf89db"
    sha256 cellar: :any, arm64_tahoe:       "c054276e1377bdf523507f00df83871b6a0100286cdda68bebe4ec4b91421923"
    sha256 cellar: :any, arm64_sequoia:     "31b6e3f4b671668317f1983bf0b6f68c223a69ac1793ca6cb86fcf9a09a9877e"
    sha256 cellar: :any, arm64_linux:       "f5ba42007262e0af0df8d9a9a2eb584ed27f5efa3422a03e008f527d75d22ff6"
    sha256 cellar: :any, x86_64_linux:      "8c7e8aa732f810429ecce2da681bcf692da66faa8d4243132ad1e694d6a07d16"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["ORT_LIB_PATH"] = formula_opt_lib("onnxruntime")
    ENV["ORT_PREFER_DYNAMIC_LINK"] = "1"
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", *std_cargo_args, "--no-default-features"
  end

  service do
    run [opt_bin/"memex", "daemon", "run"]
    keep_alive true
    log_path var/"log/memex.log"
    error_log_path var/"log/memex.log"
  end

  test do
    source = testpath/"claude"
    source.mkpath
    (source/"brew-session.jsonl").write <<~JSONL
      {"type":"user","uuid":"brew-user","sessionId":"brew-session","timestamp":"2026-01-01T00:00:00Z","cwd":"#{testpath}","message":{"role":"user","content":"Find the homebrewneedle conversation."}}
      {"type":"assistant","uuid":"brew-assistant","sessionId":"brew-session","timestamp":"2026-01-01T00:00:01Z","cwd":"#{testpath}","message":{"role":"assistant","content":[{"type":"text","text":"The homebrewneedle conversation was found."}]}}
    JSONL
    root = testpath/"index"
    root.mkpath
    (root/"config.toml").write "auto_index_on_search = false\n"
    system bin/"memex", "index", "--only-source", "claude", "--claude-path", source,
                       "--no-embeddings", "--root", root
    output = shell_output("#{bin}/memex search homebrewneedle " \
                          "--root #{root} --machine local --mode lexical --full")
    results = output.lines.map { |line| JSON.parse(line) }
    assert_equal 2, results.length
    assert_equal ["brew-session"], results.map { |result| result.fetch("session_id") }.uniq
    results.each do |result|
      assert_match "homebrewneedle", result.fetch("text")
    end
  end
end