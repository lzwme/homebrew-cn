class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://ghfast.top/https://github.com/ferronweb/ferron/archive/refs/tags/2.6.1.tar.gz"
  sha256 "eac5d06cb4da9865c6c6cdee41296430f6b9fc37733464a59b933b315d46e20a"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop-2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a585bd5d24264070b86f7f001240a080448ebe37d4a90998a6b11108e4d57b1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c9cef73a2554b2dd36f20539f0fba4a358f31edf507c6e0dcf012aa0f3c57ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c443f98d95a88639ca60946fb6337fbebb103035961b9953b10a7a819dfdf7dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e9f810ccb92db42630ee485553dabdb9a6ecb530f2dfb09e2a1e959f06f417f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1225d5274c6288d7b2b8e48ee7b7af148cee010efd94ada3a407e8a34884ed11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22aefc63065c1263eb556143d5c93b0f619d52f61d97505017a81dbd4a91ada5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ferron")
  end

  test do
    port = free_port

    (testpath/"ferron.yaml").write "global: {\"port\":#{port}}"
    begin
      pid = spawn bin/"ferron", "-c", testpath/"ferron.yaml"
      sleep 3
      assert_match "The requested resource wasn't found", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end