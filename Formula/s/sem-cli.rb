class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "c6ab7027039c8a2184bb270073403b40b84e99d496bfdd13df2a180a3be898d1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07e1a77998f5a43056499f58869796bcbc2cd85167f89863eac8025dbaf17273"
    sha256 cellar: :any,                 arm64_sequoia: "59b83e71e01fdcc6e43c3b5188821e679a2ad8ed24e46070d35d3167e66d1ffd"
    sha256 cellar: :any,                 arm64_sonoma:  "83646955c7f8c236f196ce2c58f99239172dd1277d6d3ffa03378d2921c7840e"
    sha256 cellar: :any,                 sonoma:        "43b0134cc4147e3fd3d3c7322e6b20d3a51a9c7bbbf18a65e0f06e72a4fb93dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1003b4e310ea1906bfcddac7eb841389681b2b47b9a81f3e7fb9c436ccc89713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ab50f6ceb27f2be7923adf9c1e49691c8b1bba51121ae94ead6bcebe7eea74d"
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