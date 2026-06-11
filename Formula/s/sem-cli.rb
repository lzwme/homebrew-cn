class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "4db9004aff4028269f54be0e0986231ab4027286523135660f0a51d22008191c"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "329c2776af016136244e7ca9df97ddedfac2ac8c4164a5842bca781ac974cc8d"
    sha256 cellar: :any, arm64_sequoia: "6dfde84e0dd6bc81a30c1b4685ad44d2ffda7ab83daa61dd6f7464ad42ea889a"
    sha256 cellar: :any, arm64_sonoma:  "4eafffb0673f47affd67053876a4980bb3baa62022a69836e368549752012279"
    sha256 cellar: :any, sonoma:        "ea22649d342ff9a90253ae57f968fbe046c3cf9e78a5f0c8f1c6ce954c65c653"
    sha256 cellar: :any, arm64_linux:   "01844f750c665e15684a5c8e888e6a88167d3db5175dc1e71199bf19ef05eaa8"
    sha256 cellar: :any, x86_64_linux:  "50420fd23ff8890e13cdd3807fb11a647e2372278570b01a3ca3f314cc8f091f"
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