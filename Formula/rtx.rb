class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.30.3.tar.gz"
  sha256 "489689e79655a341a0cecf13b81eba471bd9497a4888a159a5eed0d90b3c9fa7"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c2460712ff5ad8f65f5575c2081727b3617774eb08f8f6d96d89fcb46284235"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12c67d048c6476e74acc57a47dfefc1a7d05674f2344d2c68219ff33f62dce5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fca738b2bf5cbf6aeb62ad205bd2ddabe8e67a66faecdfa6cab786a1ef0d325"
    sha256 cellar: :any_skip_relocation, ventura:        "acc36fcf18216322daef8305df1acd8f2d518c2cf4d416e84868cfa7fd30e198"
    sha256 cellar: :any_skip_relocation, monterey:       "7175735dd3629adde51edfce82ad3bf2d79cd4d32844e30cb4ad96b7cf0fcf93"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fe2337ec2b26e49261c7a8a4cf3c8cf889f66d6efe4438df2338ce2dd16507a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4461d446b7f21c85b2307c60104dae3ee20be5a35f7679d14075c3f4895d2d6b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end