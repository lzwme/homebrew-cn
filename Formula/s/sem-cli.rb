class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.17.tar.gz"
  sha256 "637272d2df0e3903378bef76361336f5e6a9988cde89546583a9c3b104114f11"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9dcf041c51b5d3260881229f1ad35388b8e4217284bc25c29824eaf44d4135a6"
    sha256 cellar: :any,                 arm64_sequoia: "bcc618b7ed918562e682704817a7f2cb1c80512a1d6988ec5aa26256db053a1b"
    sha256 cellar: :any,                 arm64_sonoma:  "25d16c974dbc22c6dc5705ada172977a46f6e15e56837963c157a783a688a3b1"
    sha256 cellar: :any,                 sonoma:        "57e79012a68eb96b3d13870656c47a9e500533b41170b7a3cefe944b6acd9050"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eacc29250f33d0830cd191daf3d1fc306f469e09e0ac4b83487b8e6a1499064c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19ce6026f91f8a5f4ab6d541a3e98b33ecd115a52cc33cbc43f12c4d0be3c19f"
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