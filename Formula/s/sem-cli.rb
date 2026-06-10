class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "82878a4da5859035309340053619f52c470587cebd7118a5d8853ff06193eeb2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b441bfe3b4a07009bd0b823d62d6a34173b56d2956497f97baac1ac01d43572d"
    sha256 cellar: :any, arm64_sequoia: "4e7f41180a0f93ac6e165660fcca8a1fe63729a9f392f1a5a899dc7fa6b9f30b"
    sha256 cellar: :any, arm64_sonoma:  "2d05e477b8ce466626c5423dfdf72ae693eb77eb56729f6e64f0c63111cdc2ae"
    sha256 cellar: :any, sonoma:        "2ff34d6ae9a6e7928816b42fafc0e65e1940a398ff9c36862b113ebd48d5b059"
    sha256 cellar: :any, arm64_linux:   "9d0f6a5eefdf23c44a49cebfa88225e2efc9a6729e3001126319e1dc7daf2e18"
    sha256 cellar: :any, x86_64_linux:  "ddb6c69bcec74829abb27e39933eb7e155c995ba793c9224ee8fe5bcd027a1f3"
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