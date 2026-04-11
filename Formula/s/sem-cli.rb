class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.15.tar.gz"
  sha256 "5c2109977ac444d0a5b6328ec3875c945e6b1171e55878ae341a61224ae3db33"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca70abeb1665fa7e6ce8e07bd2bf71a5b0dd2ef6b8d348fee2df08586e5daf73"
    sha256 cellar: :any,                 arm64_sequoia: "5ad0cb64498fb85e30253fb74289fc366e0a874803f277281706f8e0faa9d818"
    sha256 cellar: :any,                 arm64_sonoma:  "97573469274471502925368538db88f0d67112111287001524af4241cc9d19d7"
    sha256 cellar: :any,                 sonoma:        "97e54492722dd9a0cb44162901e78d99bdfdf497a3199eda4bc578890392aced"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9599dcbb4820ee8bbc0ed436a60cd07371861794506494b911f1bc3f2d02aaa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "690d7cbdb26ab634d3ec4c3fb8253026939cc943c0c653130384c18567379046"
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