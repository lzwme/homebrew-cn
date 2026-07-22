class Droast < Formula
  desc "Opinionated Dockerfile linter"
  homepage "https://ewry.net/droast-dockerfile-linter/"
  url "https://ghfast.top/https://github.com/immanuwell/dockerfile-roast/archive/refs/tags/1.4.7.tar.gz"
  sha256 "4003c5b300d625fa0c2f979c674c9bd8236181cc536174889c4f47ae7d508ef4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bb0395ef3a5d15ff8badea91d165cd1cc4d2d803d2348f17d572210d6c69b96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "138516f0597d251a44f7c8c6505ffd553ee77ab645f3181c8f6bc25ab963e696"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be61b5cf60990bb17fedb649919c571dc2b2a3b2f8e848381822c777f76bd82"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c7ba562687b29a1bc17af3a7f5b1eb5e0e90735e2bd8dfd6f7723d69e229a49"
    sha256 cellar: :any,                 arm64_linux:   "64e803932069ae7f191e8e79233e68ca7118f320a8cd6d33e68594bcef817e62"
    sha256 cellar: :any,                 x86_64_linux:  "7de9b1f56f907278f6e241cce321b8056ce66e03e66b11c2576566fc4d6083af"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"droast", "completion")
  end

  test do
    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine:3
      ENTRYPOINT ["echo", "hi"]
      ENTRYPOINT ["echo", "bye"]
    DOCKERFILE
    output = shell_output("#{bin}/droast --no-roast --format compact #{testpath}/Dockerfile", 1)
    assert_match "DF039", output
  end
end