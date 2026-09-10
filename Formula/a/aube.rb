class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.2.13.tar.gz"
  sha256 "f01c1c13ed3107bbba8a834eb3bcb9574a6b812edfcb757e2799225e66c0faa3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98d4a41d784a102392fe172d7ed6d7c9ad56998511c20411c58c2dcaf2c865fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af519f5ecdcbb6cb8072ca9107507af8202d764d4d440c67b14e7887adc2555c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f5921733fbb1730fc8e6be19ba2f42f7723252a906121d07c304ad1ef527189"
    sha256 cellar: :any,                 arm64_linux:   "90fe50beb52482cf646fa1bb79cfaf2cc3d5093072ed070423a87939b7c1939a"
    sha256 cellar: :any,                 x86_64_linux:  "954195747d5f6824f4363f089d1697ff750d6fa287b364ceccef7773ac7c887e"
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