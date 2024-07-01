class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.24.6.tar.gz"
  sha256 "d3debd13771a5f9417ee5fa8ba0a8c110d249e8fa615b53ea2b0c4cdacf33f6c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba202bfc3456dd9962e7b38a39004b00626e4ed010fc5fa27340a8bb460975cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba202bfc3456dd9962e7b38a39004b00626e4ed010fc5fa27340a8bb460975cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba202bfc3456dd9962e7b38a39004b00626e4ed010fc5fa27340a8bb460975cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "84c4c58cfb1ff38ceb75b4b81adb81fc1b55360c272bb41eca9b373f0ff6ff4f"
    sha256 cellar: :any_skip_relocation, ventura:        "84c4c58cfb1ff38ceb75b4b81adb81fc1b55360c272bb41eca9b373f0ff6ff4f"
    sha256 cellar: :any_skip_relocation, monterey:       "84c4c58cfb1ff38ceb75b4b81adb81fc1b55360c272bb41eca9b373f0ff6ff4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "028903985234ce105eb38381e66f4f14ef7f8b4beb2e8e0c4af662031c0a5034"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}moar test.txt").strip
  end
end