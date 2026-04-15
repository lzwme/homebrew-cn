class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.20.tar.gz"
  sha256 "fc596a2d505c142612f57da5152381e2f00c6b133cdc3b57f38e419383f015ad"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7e81e9b25d0395828ae252884a708feb8ab36c8b841b946964b4123d915fe41"
    sha256 cellar: :any,                 arm64_sequoia: "85c125a82edf88c01e85944cef9f018476d805d6474cac37699ad4a7fac96613"
    sha256 cellar: :any,                 arm64_sonoma:  "baa2dbcf6899de8740ce0f4a1b8d76166be91a10380e64bad1f7e887771191c2"
    sha256 cellar: :any,                 sonoma:        "2a111137183ec4cdb2d8819313ecdc3b5af4658000cd1f2476769064b760f1e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b827823df16e6e2279281a86e8ce97cc8cfa8a0ad586b11e251da2b091248592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "150dae87cffd91b61a2f7d4ea374d5d5f4d9fe91b8db634dbac72d7eba08176c"
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