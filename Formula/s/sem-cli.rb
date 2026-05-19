class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "30298282326dba0a16706e30765cd05724e0dbd4ce76d60c4442fe2cdd862f9a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5a6d3de91fb0951183967ac23f60d4b48b1a32331f72557f3ba2c19a04a5fbd2"
    sha256 cellar: :any,                 arm64_sequoia: "647a5f7beda6b9b271c59dce0664a24c1b137b20aa5e9542d8acef1789bce34e"
    sha256 cellar: :any,                 arm64_sonoma:  "9f4a8f06babd424ac1c49c9e3d5b64e3725a651e553fd18551af81b9509e0442"
    sha256 cellar: :any,                 sonoma:        "2da6e944efbfdf4c460b0130f7525b030e04b4a281928072fb47b85c308ba403"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47ee5142f57fa2c852ceb3c34bddbdbd944ed2e27d9ad4baef514a9b671298e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d760094544d85a7568d3821f535b0d721f094b7a1e54c29cde8315cb6408d773"
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