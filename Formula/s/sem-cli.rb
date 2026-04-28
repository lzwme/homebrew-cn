class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "21842d8b24aebb1395e9024368e22d4ff05a9f62ed9756e3a6b236c882669f7a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48ed5276515600f7de9a7c5f857d78d288ec227dc66465b43f3bda48aef56b29"
    sha256 cellar: :any,                 arm64_sequoia: "004b86645321c11f13e23f23e2c6336e7683a779120e3c240de0c0ea4512763e"
    sha256 cellar: :any,                 arm64_sonoma:  "b7b55fb284fa1d436f9483fe5aac768b7ed10cfe7253de644cc27806a71f232d"
    sha256 cellar: :any,                 sonoma:        "00a77ea05ebd1faf9013e5bfe1f7603b659091b24b1779c2e202b6fa02590315"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "855ca1b9d21f592982e4a061d8d4954db2c555a9dd3f4464fb4ad1e23e35e91e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea05599e7de2fae4af509d23d7ee283709c1c48a664b1ce359e75046c050ebeb"
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