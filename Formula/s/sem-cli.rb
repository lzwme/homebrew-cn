class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "82578bd507d5b4095867ddf45f7ff41a51cbf2efaa731735af203b0d39579380"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09cf58a0436331ae606789657f0af26fe43d4d060117f270d158ee380221a349"
    sha256 cellar: :any,                 arm64_sequoia: "0c1a45d39bc9375c576c604edea3a7c98abe963efcec1085b3af35cabf57a8e6"
    sha256 cellar: :any,                 arm64_sonoma:  "5e186e44a77962419af13ce2c1ffc9a3470cde893d20cb66e491122c64a301df"
    sha256 cellar: :any,                 sonoma:        "99c81473f32e65e6ed97b962de57b13e586ec5b66bc534fccbe3a5b63759b921"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3be247301e8e759019b0c16751957fc2957a0baa6654d216d84557c51833ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "769f332670b7d3a296a6bf3ee2e9a66a29dbd2f3bd91df33790721ed7b232ad9"
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