class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "34274c58dc52f229e3fcd07365fc737a7ade944aab3b4d9386b930a655da55cd"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7788cb16a9aeecd3d483ee5aaeddd9fe77d100268c2079f79bfc7ce5d163b962"
    sha256 cellar: :any, arm64_sequoia: "0bb2f6b94d83f1486f479274c85a1a902ca2cbff50ec60240d50311b4c6c1809"
    sha256 cellar: :any, arm64_sonoma:  "e6becef1e9012e3fad32ba3aaa66f9d58111a342daa5ee2e9b2dfc4ccf4b7f64"
    sha256 cellar: :any, sonoma:        "f0c738b157ea872f99df48f3e3ea30fe505562c17d2ab37a9057a003287a3dbe"
    sha256 cellar: :any, arm64_linux:   "43cd031e72f192d0e993135c15a2c34ff44156890e59b1eb181836648f9320e8"
    sha256 cellar: :any, x86_64_linux:  "990df2287742f2a7815a1bf63aae1cc3cebd302e4e4549142893a7564c795372"
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