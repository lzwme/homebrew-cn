class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "5a53ea30a7778419f92d69513435104de04b11f40a3d0e75ece10db83b53ad2a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "df139d469922ac1c8f96f1b8584b67e8cbb6f8fd5649eb3e3a2accc3ce256baf"
    sha256 cellar: :any, arm64_sequoia: "2944014f62aa9a14b67e31cb945665d2d59e312e7a34d0e3f85510c2727cce2c"
    sha256 cellar: :any, arm64_sonoma:  "52caad2cadd0a0b24639a6f0773e425d1079b16e48ad04973092a62b840f15c7"
    sha256 cellar: :any, sonoma:        "5446d3676253b9388b509f6cf58ed5f39e569a235309a9ca9ad54900abb3e15f"
    sha256 cellar: :any, arm64_linux:   "4704bc4e50adb732735f69ce5d3775fe4d625a8b045162b0e56e3506cc6dabad"
    sha256 cellar: :any, x86_64_linux:  "339d6eb580761a0402baf6fb540aa058b9d7341a9d77610a6130b226869fe13a"
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