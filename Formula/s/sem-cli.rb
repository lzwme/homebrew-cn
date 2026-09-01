class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "9cf030ad886a106aa26ba571e29d6b7de6b9ac37957a2f4ecea2989b91b56fb5"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "79c0527500c3768a4dbb7901b9b247109dc02929116ae69e73b44ea1236cc960"
    sha256 cellar: :any, arm64_sequoia: "5a6b84897230fe231160718cfaf2b18b566ea63107e0c16d7bd144186224e775"
    sha256 cellar: :any, arm64_sonoma:  "79691e6bebcedf9f6bd99d0bf66f6523903935ba2310facce839d30d186f9b59"
    sha256 cellar: :any, arm64_linux:   "2487d60e5ebfc3faed5469d286e8fa00bb1ea93f30e5ce13ac58ea5ca4604cbe"
    sha256 cellar: :any, x86_64_linux:  "0938711f5387c644182cc4676fb24d27d11a8e7a55a347308f1145b7ce617c2e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sem-cli")
  end

  test do
    assert_match "sem #{version}", shell_output("#{bin}/sem --version")

    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")
    PYTHON
    system "git", "init"
    system "git", "add", "hello.py"
    system "git", "commit", "-m", "init"

    inreplace "hello.py", "hello", "hello world"
    system "git", "add", "hello.py"
    system "git", "commit", "-m", "update"

    output = shell_output("#{bin}/sem diff --commit HEAD --format json")
    json = JSON.parse(output)
    assert_equal 1, json["changes"].length
    assert_equal "function", json["changes"][0]["entityType"]
    assert_equal "greet", json["changes"][0]["entityName"]
  end
end