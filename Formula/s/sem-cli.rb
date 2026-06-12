class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "5d458312bbb293a88495f5afdc0f9984dc81fd986bbeb637e12ab92a269f6dec"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "194abb28867c7ad7c89313ac7a5a584c7a1dae84830b97502af114593c4d3dcc"
    sha256 cellar: :any, arm64_sequoia: "23f3a9913877497109cb7534cd98c0ca6d13b20987b86a29689ffa99d167e1da"
    sha256 cellar: :any, arm64_sonoma:  "cf329491b04a514136189cc1a9dd1ccb382e2ad4c2a4d2c10f2d5a52d545e99a"
    sha256 cellar: :any, sonoma:        "ce9535d512442559c81a09c708de6263a06bb702c78f0b55f09e34211b931a3c"
    sha256 cellar: :any, arm64_linux:   "1929ca3b6e6aa1e5ec15d49ebd032ac26693b519cb4af01a22a163e7e3c1cc65"
    sha256 cellar: :any, x86_64_linux:  "eb8f1ea1d457752845b73fa912d455acd477cdccedad28bc07ea86eb0f3486ce"
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