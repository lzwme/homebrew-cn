class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https://gopeed.com"
  url "https://ghfast.top/https://github.com/GopeedLab/gopeed/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "6fe338f933fc361cd924b0e14a4973532461520bb5664520928e0c4e34f0f5c0"
  license "GPL-3.0-or-later"
  head "https://github.com/GopeedLab/gopeed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63bd804cb83bf64f439045dd44b7214f218d20a67f7a3724c182be2b12786f02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d4d5b4f4605d55a802506bf26f905d1d6f3892edc696fc6bbf25d2ace2ef155"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd86636304d11d4b81e3da4a0106def1592b1974dde20254295ee430c854acc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6436da8681fd9f1b68803fc3a51a0f0d6400680ced289886b2c5032e2866078"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2a74a19f1cbab6f1ae81ea5b89395e03982d90430b954b0eca8115b2bac19e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "343207f3b95eb3fd5f8eacffd3bc4a9f89f9441671173a87c740d48b3784439e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gopeed"
  end

  test do
    output = shell_output("#{bin}/gopeed https://example.com/")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath/"example.com").read
  end
end