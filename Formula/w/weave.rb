class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://github.com/Ataraxy-Labs/weave"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "5b21fe1aba862270698fbb15044c49ab932d036a393376af67b763a8a8c2bee4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d7aa1a7b8b6e8848d6917e8a409391fed31a11dc2a29e31521b16dc4a71de804"
    sha256 cellar: :any, arm64_sequoia: "0472a126b9462f1e979613706b8fc8f448d3bdf40db818bfe820a445403d5603"
    sha256 cellar: :any, arm64_sonoma:  "681e6bca46b47020f4567726807e78abd4a9db1d29dcba2fdc3924600c23d52a"
    sha256 cellar: :any, sonoma:        "5e62940994fde23505c41cde6cedc8051d23f08476c2f1527cbe376a0e2c66ab"
    sha256 cellar: :any, arm64_linux:   "e7f98e543e140631b73cbd7ff8030819faf1d512235af9e47adff855812e05e5"
    sha256 cellar: :any, x86_64_linux:  "3c7bed304b833c5e7b74601a410f46f7ab8e76ba2a28f9d20d97a741581ed062"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/weave-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/weave-driver")
  end

  test do
    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")

      def farewell():
          print("bye")
    PYTHON
    system "git", "init", testpath
    system "git", "-C", testpath, "add", "."
    system "git", "-C", testpath, "commit", "-m", "init"

    output = shell_output("#{bin}/weave setup 2>&1")
    assert_match "weave", output.downcase
  end
end