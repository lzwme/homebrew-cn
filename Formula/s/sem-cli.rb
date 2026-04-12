class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.16.tar.gz"
  sha256 "c1529db0bb0581dc4908b77192c117768af5f7855acf95e93663fbd7dc00ae55"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e26106a69f7d689f970c4b7d8f22ea2c51aa540b612a064e3a35e5b4be6dd504"
    sha256 cellar: :any,                 arm64_sequoia: "80dc7078757c83d1ce84915cf5e2aed2bef267f3746776390cffc9f579db2258"
    sha256 cellar: :any,                 arm64_sonoma:  "db447af099743f6247cba915a1b9a08e16e999e5148b45cf349e2ced1c51bc23"
    sha256 cellar: :any,                 sonoma:        "12db985e22ec9e20f343d1a8752e3d1e520b82437e631663d6066187b1d1cc1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f987aa34677525ac35048dd44301a95ece9486b92a0fc198667219bd14fef90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aec22a8834a041596ae8323c39974483e846b00f294bc83dcf5d95269dc47cd5"
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