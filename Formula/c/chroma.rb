class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://ghfast.top/https://github.com/alecthomas/chroma/archive/refs/tags/v2.21.1.tar.gz"
  sha256 "8f7ae430fe212bc33bc2c786e278777ce54a6300d92fe33de93f5d1efba148f6"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66b29acfb00ccfb3fbd484dab6ec4cf790d68b7bcc908e26d9b9f9e8edf94aee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66b29acfb00ccfb3fbd484dab6ec4cf790d68b7bcc908e26d9b9f9e8edf94aee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66b29acfb00ccfb3fbd484dab6ec4cf790d68b7bcc908e26d9b9f9e8edf94aee"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ed1fb3b057a76aa1cb5fe9be745e97a5f46820ed99094f2862daddae3d2043b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b608ed5053e69072e2cdd36fc2fccce284ae8fd544394000c4324db4e39ea81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed4af89b4fd481e4c797e5428655200683bd9b48df6e7cbfc7f1576b30f9e774"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end