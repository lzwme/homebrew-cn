class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "b9e74c7da9fc0f6ee63a993d590cc518973cae912f4fb6e2f2c44c9072b03ac6"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f727bf8b8b5b4df3cf05becd189bd8b7d63146ce8e05025798c60c613827e0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cea03964cf0c118ff3f88f7c8a0e2e80d4b4659f76f5236e0586e773ee9e00c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65854e26f91a36b9bc3e78408f2715ca02b92bf9327b17196c118ba8fe5579fa"
    sha256 cellar: :any,                 arm64_linux:   "5ff198951ef926c04324653e8cf974e97aac52d10e650232a941d2d8629c3fa5"
    sha256 cellar: :any,                 x86_64_linux:  "f8abc5fcf81055f1e86702ec914eb18e8c0420790b8d7d6452537e8ad6769042"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end