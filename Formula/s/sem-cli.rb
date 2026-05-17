class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "7031764ce670b9d5ea38eb3d220da5ed9ce1637af1a264641ccfc940d1c3fdf5"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6597e6061c78ae10a65d0ca0b7532ee4554c2c7b3ba82dc55f4536423df1a75"
    sha256 cellar: :any,                 arm64_sequoia: "c018183474f46b76573b22203293ce86b37a00e237e177f792a30b8d5eb3f814"
    sha256 cellar: :any,                 arm64_sonoma:  "c57d8c504a1c24be9ffcf6843b1a1d0404174d879e5976283630dd80ab249af4"
    sha256 cellar: :any,                 sonoma:        "7ad5f8b5f53a4a0488cdf4f85d562bff5dc4d591a8243c4a7cd652b4cd375482"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08356b8016f1060e18f2ccf6657199acc5d07241a4ccf89491d26ee5d1bada76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f16877e09ddc1f1921a8d164e33a22b0ac7ba6e2f6a3bb40371293442bf12214"
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