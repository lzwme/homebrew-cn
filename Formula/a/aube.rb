class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/endevco/aube/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "040823555a3301c2b719f808143525d4f98708a9a38c3f7f675ce5e9b725342f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e30e732c050db9cb0e5b11be85f574f7fb08ba8a94a289d769d50a8ac8beaa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e947e065d898941a19a7c7b8ad2f052cb42a64ed3a83d74b086589f67b988ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4fa199fbea897f2dd1ab6a97bc1230b9ac7d6f03618da290a6e7712ad57ba50"
    sha256 cellar: :any_skip_relocation, sonoma:        "63fedbb847ceb2576b5c4147b4ac42e9b66d2a6993d24c7329e63f6eec96ca87"
    sha256 cellar: :any,                 arm64_linux:   "eabacedc3bdeb6cc1e16a8bda075e8537eff4895b09b815419b0337f5138d8a5"
    sha256 cellar: :any,                 x86_64_linux:  "10b72f26467c3414758da8f169f18db2da712bfdf93f940246556016051ce571"
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