class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "6d7ec3f41a2a977339e9343c790075038c4658bfa4e334d08d2ec3b1940b89e3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "886aca62463bc07fd9328ba92ca482d196f260f20411d089602c410adc53a70c"
    sha256 cellar: :any, arm64_sequoia: "9f00b894a42420b767d506bfe3a52e23019349ee638e5e10747653f4f2e25360"
    sha256 cellar: :any, arm64_sonoma:  "f5ba72fa5cb5070714df1139ff6627d7b589a3f5b996970446f92aebf052e124"
    sha256 cellar: :any, sonoma:        "5ae805c6c24c7062209ad5025da5fbbbf07e8e8b97672fa80a8f643b27983d32"
    sha256 cellar: :any, arm64_linux:   "a98ea2c934f2852f0d4f2efd485773e98ef01a1d78689360d8a217acd1d59ca2"
    sha256 cellar: :any, x86_64_linux:  "4b2865873f04eff89c51fa69f4f7a6c3b96579bdf666a6beb19781f65c7a02c2"
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