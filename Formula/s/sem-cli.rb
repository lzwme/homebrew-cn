class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "16a1b77f08251ac32230bf9f1d517cf921b3c397498c26d2ba7cd77749ab9347"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "84baad36fc129c3b4566d19909c1955c5eb78316c534c6c7923709779d1edf0d"
    sha256 cellar: :any, arm64_sequoia: "d5ea94906ab36e16e9280becfc8bbd1756a2d0fbc2353e88373430d851dfcdb0"
    sha256 cellar: :any, arm64_sonoma:  "33046afede4b904d84955a0dfa802f84f5bb4d9c25362a7a498513daa0489450"
    sha256 cellar: :any, sonoma:        "7792133b23b0eb8a410f3d60341f196cf365cf752a7e281eea5d573aae045e7c"
    sha256 cellar: :any, arm64_linux:   "d09ea1ce5f5787560b4ecaf9f2f5c806150b5e74e5f95eafe8064c6377fedbcb"
    sha256 cellar: :any, x86_64_linux:  "afa0f6e75f08059383d156b33d1ea077ae155cb8344309d1e3f119bbe1b7cd1d"
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