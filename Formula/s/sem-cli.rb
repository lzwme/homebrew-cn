class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "9e85d5150731f0f2e02a88c2f6849778498598c7d10b7443999b7356522596ea"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ffdd8f93b832b16013943c54deb826eddb5c63f24e6e086af9adb39961b1e761"
    sha256 cellar: :any, arm64_tahoe:       "80b8bc3dce2ef187bccaa271737cde64044b1d9dc0b54bc618d73f672cebc291"
    sha256 cellar: :any, arm64_sequoia:     "94cf0882e08d758dfb854629c794c3b1fb8158d8e69adf1f72a84e98f77148ee"
    sha256 cellar: :any, arm64_linux:       "fed054ca2d5115d791df1f9dfb3d25cf04b3bc675ecfdc28fa9e330702188722"
    sha256 cellar: :any, x86_64_linux:      "41bb57dfc9d3d416b485a3760bff4f40356fa6def3ca1b7499732cf081e9e0f5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "crates/sem-cli/Cargo.toml"
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