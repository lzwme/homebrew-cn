class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.22.tar.gz"
  sha256 "58ea2eafd51f0429f6400a472f8416d39cbbcdb64de3ed496aa906dc7dbed845"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "278f2e898b4813c9edb95400a20aa6f9ade7eea4d04c57b357d890f9ad0bc5eb"
    sha256 cellar: :any,                 arm64_sequoia: "b21f54b761e46853d3ba24c3e3376f16939ba8eaeb768f630bd192f05e30ed02"
    sha256 cellar: :any,                 arm64_sonoma:  "be8e202a7eb2b2153b400d16536814718bde85edb14987e058f5d6a62f208f4a"
    sha256 cellar: :any,                 sonoma:        "a27e7199e2f675d4945eecc6c786408dd164c96e089a9b5d639c5630eac8f51c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dcf17bd6e990d9a844158dc7550d7af3f033257706e936da6dbd37f7918f25b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d7af97e3875bd015f76b9d71ea6da21334accc4cc6c14da2d65d17720aab17a"
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