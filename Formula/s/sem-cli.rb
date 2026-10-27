class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "90b22e7428e8873a3a715e02d1b3b4d53df8dadd6475b28c5b6e499d0dd84e0d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "be44eba068e6b1334d7d21bba10037e7b90fbb52d8f5764478a76924f974fd34"
    sha256 cellar: :any, arm64_tahoe:       "4b7e2a018221144a9339948f70882334b8ea0a8a031e38a6c4c0527b64e92c44"
    sha256 cellar: :any, arm64_sequoia:     "ac1571449e42154325e6bc3db6d72052a70a144985759d5c8343a17a76b9a127"
    sha256 cellar: :any, arm64_linux:       "40f94446cef1727891dc8463a76ef415fe30a706b3f94f6caf9b349da9c86f33"
    sha256 cellar: :any, x86_64_linux:      "5fe11b435a9c1b5c116c5ff3f4153ff596c173acddbd14704176119364d7b509"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@4"

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