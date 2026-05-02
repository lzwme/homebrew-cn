class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f255c259543689764e9bc4819d9a82a5d1bdfffe22ebe4db04b657db9bd46aea"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c4062d73589a3d3806a70bc21d10ab1aa5f0e54f1b12c4fc9242c6fc41fe1d5"
    sha256 cellar: :any,                 arm64_sequoia: "32780518b7cfb3de0e5c286a2f8743d134f2de463b7f00c12b679a126fdfa1b9"
    sha256 cellar: :any,                 arm64_sonoma:  "a741e19cca41cf6796aed11a331a5ddc06922faf834d153dd678963c72c2120d"
    sha256 cellar: :any,                 sonoma:        "355e8c57c5e9d6be10e806156901c29345ad705a1c83e489ee6db0ceff0ba810"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95b5a65a93b0b731c20b880084c2d3d14c31060159a8867e2a6f064738889721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98bb5547bd16957580c4341273f4173ec9d166a743147feecb778fc9e7b97aba"
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