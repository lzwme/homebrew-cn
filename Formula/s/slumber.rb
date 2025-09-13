class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://ghfast.top/https://github.com/LucasPickering/slumber/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "01ccc586dceeb63bfa8c2f4797db4f0d5d52f51a2cb7b757a37da98333f4f960"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "840467c69725f512a0d15482ef02e117590ae5ad9107fa22aa96c68577d5ad18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93b16cb249147aa802d1a403e275607204e7505ef44805e716c5d62f1363a10a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbcd0f3090671a985a1e86eb65f94e4a0730ac2e87875715d9002c788cf72db3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56adab0c1ce197333f7e2437bc5d1cdca2cebab405d788bf7ba2de0fa3867bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3890ab62142c1b01aa92590dc8571b871e5d77199449e342d843b4db560a7e29"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end