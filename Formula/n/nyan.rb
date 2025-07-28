class Nyan < Formula
  desc "Colorizing `cat` command with syntax highlighting"
  homepage "https://github.com/toshimaru/nyan"
  url "https://ghfast.top/https://github.com/toshimaru/nyan/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "1267e14579a67ea43cc8dbbb52a106446edb32389138ff6d9933dc1f6c84c32a"
  license "MIT"
  head "https://github.com/toshimaru/nyan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1721157f2792d7cdf534b614ca15ec4fef853642152430b1bb27ae0f8b64e558"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1721157f2792d7cdf534b614ca15ec4fef853642152430b1bb27ae0f8b64e558"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1721157f2792d7cdf534b614ca15ec4fef853642152430b1bb27ae0f8b64e558"
    sha256 cellar: :any_skip_relocation, sonoma:        "81016155872fbe67b72378e7ef73e0b0419895b094325bc5ba79cdcee5b328f3"
    sha256 cellar: :any_skip_relocation, ventura:       "81016155872fbe67b72378e7ef73e0b0419895b094325bc5ba79cdcee5b328f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3de0783be16d777e55002d945c19d916010bc539c85b24883a1e4a20a6a9f832"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/toshimaru/nyan/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nyan --version")
    (testpath/"test.txt").write "nyan is a colourful cat."
    assert_match "nyan is a colourful cat.", shell_output("#{bin}/nyan test.txt")
  end
end