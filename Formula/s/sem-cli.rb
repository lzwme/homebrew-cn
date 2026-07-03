class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "ce51c2045d6526f139bf1b2e4fc9a29273f5fd83c4183b0af8eb6778afdd3ba9"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5b0150fa97877726f4ed7c75f4abe8f67e33cb9f96af51ede25e1a12c200c45e"
    sha256 cellar: :any, arm64_sequoia: "a3455e3c797ec3a4e1d5496f1ca66317df3eb66aa852e1e93c7558eb614d6d7e"
    sha256 cellar: :any, arm64_sonoma:  "592fbb0f57627a4775683caf8e83e2f96252b72735d334c888d1778253757af4"
    sha256 cellar: :any, sonoma:        "5719ab6d91fa88eab942d45649649dc5776e19f1db1cfafb00b27a7d32413535"
    sha256 cellar: :any, arm64_linux:   "ccac7257925d0f46135e722193dabdd9ec4ffb7d2b1e11e1a7a94b954e00b444"
    sha256 cellar: :any, x86_64_linux:  "7cc45e42feb65094a32cfd36e0aadbc6c2bd35f229631d591ac6b31f1976daaa"
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