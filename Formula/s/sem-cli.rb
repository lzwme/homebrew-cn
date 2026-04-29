class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "db9d562d6ee1e19cc7267a75fbc2a8d3574037b541d9d0121e22a5a4958e538a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5dda28dfc2200e700e9488f48115074f2bee6878a512c2380a9319a888767c72"
    sha256 cellar: :any,                 arm64_sequoia: "1e18d969a8eaca01be76281e8032f2dbb1ee3ac4bc54a2135195f41715c67046"
    sha256 cellar: :any,                 arm64_sonoma:  "37b2727b4d5d143c92a5240fdea5818c60817e94ffc992b6fe9b002a7da37e6d"
    sha256 cellar: :any,                 sonoma:        "62131456d582ec6b55718f9d22aa61241a7b34fead7283c305cdab5c2e627ebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f6f254f8ab34edc0c56d9b6c5e3b181f7e385a284207ce78b5c5ec67c6853c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f09b63e75891023e722d106daef82c7aaf0c75bd01fa04d7d9d423be8850d4e8"
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