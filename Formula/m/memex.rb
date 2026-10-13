class Memex < Formula
  desc "Index and search local agent conversation history"
  homepage "https://github.com/nicosuave/memex"
  url "https://ghfast.top/https://github.com/nicosuave/memex/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "2b63ef8ff63c3a48c767cbf0eacdfbdbd0592658e6349e501ba4a18f87e784f4"
  license "MIT"
  head "https://github.com/nicosuave/memex.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7bc1168c2877b177cc8ce326f79080540b2a8dee3d256ac58cc51589a3918f63"
    sha256 cellar: :any, arm64_tahoe:       "18bbb83e03530584d7ab62ae00f778b6e2c7d9fd547acc2981c8b0fcdb6a269b"
    sha256 cellar: :any, arm64_sequoia:     "88dad035b7c648ec9b0d1ce38f360d0fdacbd0ac55dedc8bd2986a674ebb2abb"
    sha256 cellar: :any, arm64_linux:       "47cfd79a3b15934d4e9daa5710abe47314b014ab38ebc7d9d0ac554d38d0fc45"
    sha256 cellar: :any, x86_64_linux:      "2035ede34b4f98a1c4049de3e1f5253c27b89cd590b768f2043ceca65bf27dd2"
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