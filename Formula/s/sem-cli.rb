class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "d5cc43458378c9aebf016daf76c4a163cc7fb059abe670cbde4fae85fa14e32a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b10b7e2a428aa85a27ccc494c0c38094e0e59a3af84d42542bba5fa6831be507"
    sha256 cellar: :any, arm64_sequoia: "0e13f3caa3e58ed7028ce6efb3493a4834c1e83c12654f9f5093aa92dcea587b"
    sha256 cellar: :any, arm64_sonoma:  "2ec7650f6a83a72a7a58dcfd92f8a0793418a920122eb33936770a5ded879291"
    sha256 cellar: :any, sonoma:        "d8825f35a63e3d967011bfea6ed07316b249935fa523339cff3435d30ea66e0c"
    sha256 cellar: :any, arm64_linux:   "807486cb4bcf6a5702d26c12287856786677d20545289aa2ed860627f77c1a18"
    sha256 cellar: :any, x86_64_linux:  "b3e78cf4fb9c440858ba1e468e8883b620ffb6889912534d54f7605c1474e746"
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