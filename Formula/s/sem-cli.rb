class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "526efde2aa9322eb5938e4c41e315eec16df083e39f5f7d759d58db386b08f8c"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "018b64ce2ee944116854c2d2aaa39f665ed3b13445e13eb9f8789feacd72f5c3"
    sha256 cellar: :any,                 arm64_sequoia: "124199408f4ccaad464a82a5b9af6218c1d7c5e6a8934c56e6b0cccb6d621d69"
    sha256 cellar: :any,                 arm64_sonoma:  "493e79b96b797d3d5e18ec5c386d1466749d212d6b4c6678712f656b97c91fec"
    sha256 cellar: :any,                 sonoma:        "20ade01f93ad7b23779655a461d8208123d4ba4050696151ca9b01fa1d30135c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58dfd3da7dd57f75f38dd731aa8bb8222f2c14341045a1db3549bf42e9e0bf2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "008f5f5b073a8d0fafbbddef540d859796b43487faeb2110054dacbb8a02ab04"
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