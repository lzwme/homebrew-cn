class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "d29ab5973143ec8867279ad771bb82ec1c2b120d2674a434faf3ae576ca45970"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e474bc90cba5dce9ab3e99caf6838e6bd402d09c0a5370c6e9f706e00779da9f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "01ee8a4e10dd832f5a14d0a01db0fcdc929b670944c9717a66b60ab718a57215"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3b34edc299c3b9bda2ad3bc823333d7a20fe0f84801c73bea3ca37d13e71d967"
    sha256 cellar: :any,                 arm64_linux:       "5c53d57707700f18bad25f070e970ee6242dea10850b412257e89fd85e9d3280"
    sha256 cellar: :any,                 x86_64_linux:      "f607a1b4af72589dc22f16d3075e43de2c0d32bfd0636993536d4f5c991a0795"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  # Test installs a package from the npm registry
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end