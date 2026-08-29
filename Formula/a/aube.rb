class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "5f30d1d9d0bc494579cd822756fed3a11fc963c2063b5aad529918a0c1d119e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89cd9c2f354c84a5547ba6340db7e4174d27b19900b06b24e17dfcc888627fae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24c21e12cc9615715d16bc49b9298bfd230cf263b5ffe2a9ac42ef56e2797c44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb43380b9ff6b601492878432dc666fd079f7553c68534b3df629a2580e73356"
    sha256 cellar: :any,                 arm64_linux:   "d9d81ca1fb4da568182e8a57cecc7f066a9ca8d2fbb1932f535573f0ce125bd0"
    sha256 cellar: :any,                 x86_64_linux:  "f128daabc648aa0e7147eeb2a7c75ecb78b8228679f2b7e4c19aa430a0da4791"
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