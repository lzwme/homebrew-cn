class Jnv < Formula
  desc "Interactive JSON filter using jq"
  homepage "https://github.com/ynqa/jnv"
  url "https://ghfast.top/https://github.com/ynqa/jnv/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "7ac4379a04732c250d5f818f58fbf14adec6db9188157789cd82ba3ea3c555d1"
  license "MIT"
  head "https://github.com/ynqa/jnv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3085b4cbfab5d16f7e25d9843ae8d58ee3a7d0905f237bd6caf554d63e925fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9f216cec58e6cbb38a334a46c4432965006fcb1b3d0979f6ace307de11f09cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4717de2f1daf78a1058897714da397c939ee89811202a1c53fc49f2d646bd93"
    sha256 cellar: :any_skip_relocation, sonoma:        "e26c27165a40790c653f145837c097550f49210a01aed0c314f353437f64432a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45988febfad99d33d18c24bc92bd9198e8bacd3185abaeb781d12c315a6ce122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1163503fac03d94fc7ef1f00031a3df900488e15407737ae05fe220ecdfa8dc6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jnv --version")

    output = pipe_output("#{bin}/jnv 2>&1", "homebrew", 1)
    expected_output = if OS.mac?
      "Error: The cursor position could not be read within a normal duration"
    else
      "Error: No such device or address"
    end
    assert_match expected_output, output
  end
end