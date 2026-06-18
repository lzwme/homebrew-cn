class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "332c3e992fbf8349bba59575dfaeb4d9dd49b8ecdfe09d8b642792bff87f7f28"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b2971d579626c635696f5cffa44b055fe6f3e59d2746ae179a747b0f1a7f7ffe"
    sha256 cellar: :any, arm64_sequoia: "1f39ba0a6ce0665f562f29e3dc6e91b5529e25378b74a8472c7fdb5f5a62783d"
    sha256 cellar: :any, arm64_sonoma:  "1f2ecb18c21e3ae5057bdbdf74094b5d13713a49ea7c5df3b9ad2dc5a6197003"
    sha256 cellar: :any, sonoma:        "fae9dec6340537ce4001b340427c22189bb917fe5aa39eb22788b1b87522adf8"
    sha256 cellar: :any, arm64_linux:   "a9fd60fb1398e1e769cbbd9cc6a2a611669166d8b0e0febb45f853003b83742a"
    sha256 cellar: :any, x86_64_linux:  "3c45d95ffa3d5290e79f8e6259d7d2fab07e21509fe7615bf262c7481d2b7ad2"
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