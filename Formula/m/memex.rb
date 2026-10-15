class Memex < Formula
  desc "Index and search local agent conversation history"
  homepage "https://github.com/nicosuave/memex"
  url "https://ghfast.top/https://github.com/nicosuave/memex/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "636a1ef97226f6e491e778112ffed154c8f7a6b933f57890e12e68afba0a52f0"
  license "MIT"
  head "https://github.com/nicosuave/memex.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "76ff97cc304805961da5d1dc9b4d4452a4b73ca5f530096feecadfc5b2f3d389"
    sha256 cellar: :any, arm64_tahoe:       "07e01f6b5160d4ab4feca27eb0191d11076bf6b6ac9bd5a505935475cbe68e5a"
    sha256 cellar: :any, arm64_sequoia:     "640dea7538dfd2601be9f748978035875203683297d44583685b7d15aead57b9"
    sha256 cellar: :any, arm64_linux:       "8ca3d3e83d9ac01b0b07ae34fed12dabc4618bceecf46c438ea8125ddd3fe73c"
    sha256 cellar: :any, x86_64_linux:      "0eff47792b9c7e48807b336826743563ae157d9a482bc00aeac42f9bec18d3dd"
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