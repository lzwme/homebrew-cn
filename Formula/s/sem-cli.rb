class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.21.tar.gz"
  sha256 "043291d09259c0ed7d0efbd29157849a7f6b681814335a2149a7e4aa53d08859"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "398c3c92b0c8903f5538264ecc645d05b8dbbe6400f8d332a3f4591a3499c458"
    sha256 cellar: :any,                 arm64_sequoia: "fd407f97cb537d8784f5c35167316c20b176c061e9eddf77e92c01f5784005be"
    sha256 cellar: :any,                 arm64_sonoma:  "8878e70b0490d494f22c577b5ba1eadfac62eb6c44678e14f3b4cf52e3a185de"
    sha256 cellar: :any,                 sonoma:        "607738eff2b1957c45db5443393ef9a8d18dc5197f2b5ed4221b1188f470bb6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcddeb6db7df6d3a510ccce012516a054a74e4b44900dc2027adedb7f11f3107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d75a289a0a2e0a7fa8e3b45854b855aacec7889eec6710799060e77bf3e64cf"
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