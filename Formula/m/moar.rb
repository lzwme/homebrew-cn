class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.31.3.tar.gz"
  sha256 "8fd565853844ce3a5da173d885406fb1cab7d894fc8617617dc4f6a4cfe08cec"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03648fbcf2f78f75e14538ca0d796d8f97996b8e3a2f96e399aa4f4795ad0d9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03648fbcf2f78f75e14538ca0d796d8f97996b8e3a2f96e399aa4f4795ad0d9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03648fbcf2f78f75e14538ca0d796d8f97996b8e3a2f96e399aa4f4795ad0d9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c6825e31c3e460c00cd5d73bbd37400795a69fe1c133bd3b2b3a04a0af11cbf"
    sha256 cellar: :any_skip_relocation, ventura:       "5c6825e31c3e460c00cd5d73bbd37400795a69fe1c133bd3b2b3a04a0af11cbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4170b081c8381a93a3a3e336d28e85dc1689f18832ce40801ac412b7bcdb88c"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

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