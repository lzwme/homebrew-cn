class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://ghfast.top/https://github.com/wakatara/harsh/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "6b6712eea2e27bb0ed195355bc113b3820fc9bc60f55d24c415832489056abdc"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f911075a49eefb361ea404761f7597d6a27d3c8812fdcab8e6485fc402c2751e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f911075a49eefb361ea404761f7597d6a27d3c8812fdcab8e6485fc402c2751e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f911075a49eefb361ea404761f7597d6a27d3c8812fdcab8e6485fc402c2751e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb59cd374d9e6ad41bf837d6c29c2c365d819fbd74f003d192351f4455e5e412"
    sha256 cellar: :any_skip_relocation, ventura:       "bb59cd374d9e6ad41bf837d6c29c2c365d819fbd74f003d192351f4455e5e412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e02d2d447310412c6509603983626e8a3336ebaedf73b33618d0c188fa38aa76"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
  end
end