class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "23fd062db52398d13d61a1d4d8a07944487312f71d221497729968f508c4d7ef"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "441e1f60a26e53d3a368c199f90abd456ec83e4e66eedb29a7122c4437d217ae"
    sha256 cellar: :any, arm64_sequoia: "1136d4d8c0eeae9206c3fe3c168720ed7ce8d24ec628902956ba9a8567f611c7"
    sha256 cellar: :any, arm64_sonoma:  "54fe092da31038c41748ca6f48a8fc1df9ae722be654a23825382bf76200ef75"
    sha256 cellar: :any, sonoma:        "adb2361157ab865a3f56aacf44ab2e7b0c10ed6d110de2f8474044e46fcd5cbf"
    sha256 cellar: :any, arm64_linux:   "4092e06dad2cd6aef4dd9a788ff6df9cfee30888ca530f24291278f514b6915b"
    sha256 cellar: :any, x86_64_linux:  "5123d75dd3cc42b2df6f3ef2b72d16ac1a7ec0f16621a8f91a15d48def3aa3d4"
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