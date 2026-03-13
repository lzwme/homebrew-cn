class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "c2b108f92881845ea52a86975b322c5965e5849581997782108a7d126409962f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "374efc5a7ba6a8ebc9700a0797f7badf60b8099a5909732324fd10758af65ce7"
    sha256 cellar: :any,                 arm64_sequoia: "770e77d4eee05897dfb88e827e2d6b9029b3a557fa7e1fb6d108f36cf86801f4"
    sha256 cellar: :any,                 arm64_sonoma:  "d59d17e2402afd7fffb128d051ee7c14146fd48a5c149834b1db650262ec7226"
    sha256 cellar: :any,                 sonoma:        "fa009931bd2e130dfab0f5a4783b176c45d5ebdf63abb37f272c63aacbbf1dcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de79940b8307534afecdcf47436bcbd09d64b1d08e76636f1c8f9be146275e73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be35167d5cfdc548c26426ce0c9aa5197974544298c7fd876f109484b71b8af1"
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
    system "git", "init", testpath
    system "git", "-C", testpath, "add", "hello.py"
    system "git", "-C", testpath, "commit", "-m", "init"

    inreplace "hello.py", "hello", "hello world"
    system "git", "-C", testpath, "add", "hello.py"
    system "git", "-C", testpath, "commit", "-m", "update"

    output = shell_output("#{bin}/sem diff --commit HEAD --format json")
    json = JSON.parse(output)
    assert_equal 1, json["changes"].length
    assert_equal "function", json["changes"][0]["entityType"]
    assert_equal "greet", json["changes"][0]["entityName"]
  end
end