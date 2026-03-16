class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://github.com/Ataraxy-Labs/weave"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "267b516147a956719bfa13ef0b815f4351cb1f61e87a3d3370d96a96c2a970c7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "345cb908dfbab285a886b2cffdebfd51297ee4717b75495db7dd4a7bc62a8b40"
    sha256 cellar: :any,                 arm64_sequoia: "3bd026a70f26c06c27416bcfd25301d988e8f51c286e5f2ab7298b495028bd78"
    sha256 cellar: :any,                 arm64_sonoma:  "926a29a7cb3a9e3d6d23217fbc97d8cedb18e82a8e054b4d3c5377d4786c7069"
    sha256 cellar: :any,                 sonoma:        "84fe08fe1d6e7999372544c3a483dd5cefecf1cf1e6ee6f0a1b7f68e2f3b7cf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d39c629eea3fe3c9d07beae60954e76293ac4b6ea793df24a81c4e4cbd8651ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fac8d199a612df2f333df3c0bd1208cfdae853bd8f65a637f095494be00126a"
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