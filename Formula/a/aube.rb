class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "497b0f1abb8dc82d2a47ce187d0e089f747b660521137059cb3f969f0f1eeb88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b826b54571ab274e3c14a547c262d231ec31effcf8db33dd4945db29dc8f614"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d2a9b9c557423dc8c8bb5dab714fd9d5b5f2d3408cb2f71103daef9cdee9246"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b13f3621e3b438e44d9a170339c20f55c126917372c28ee3b743a6a731608a78"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce3e49ccdb5543135cf38ac919c2b442634510d3c1bcc14cfdf1ce2ff98705a8"
    sha256 cellar: :any,                 arm64_linux:   "1995445ad2dae6fd81e72fcf25968545e660e5bb93413bcefd3fbfa744c0fc0a"
    sha256 cellar: :any,                 x86_64_linux:  "782afc5793eb76f856677c8a2efe03b89f175a8638f0f23cd6b01ccbffaf1296"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

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