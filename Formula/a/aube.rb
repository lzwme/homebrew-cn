class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "a1ac76b080932acd374905e9ed8ffc47a6c0e481a0a050ed8c2b07d7576c6b03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba810aa4204dbd28c6782ad2fb7afe366edf2bdf2220a831f06cdd28a66dd55e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c31c2dc80844be92430c44ac2890d12d24ac240a4b0fa35b371996fceae5bd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e095528375ca556b3464632b2a6e48be90560f29ff199e7c02a82fbe00a1cb4e"
    sha256 cellar: :any,                 arm64_linux:       "e41dacf521d6610c306d66b804bea2a55ed5d47b49c2682f46d42d03b09960e1"
    sha256 cellar: :any,                 x86_64_linux:      "993ebbe7e263715a713aafd0552db6ba69e44739ac048dbf67c0734fe15496d8"
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