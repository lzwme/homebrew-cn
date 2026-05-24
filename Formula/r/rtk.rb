class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "be980a33ef44990bd02bde2a1d42ef90dfbfc42b34f7460a1dd489971b8c0c35"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e498ed8dfbc22bfe437aa9441f5eca3157729e69703f339951bbc29151a5dbfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "235ac77f776e70149c506a3d70bbbd6db84ffca9d575737124502622096391c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fa4a0c5661e6eb4a2a524374f234aeff96d80c4cb6a22d7344657aa931a01f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "147b05ab5e9933d2dd4a7a417f386afe6057138a68ebeaafcdd6e305994d3e15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "724832eb64da9b5c0734efed7bb2c13d06dce62d6c108e125d3bb96b7aa45204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5902a2df2807e712021974fce96afbbecf6ec1bca920645913abf0b8775a0f55"
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