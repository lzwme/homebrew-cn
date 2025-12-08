class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Golang"
  homepage "https://github.com/context-labs/mactop"
  url "https://ghfast.top/https://github.com/context-labs/mactop/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "37184bc7f41d3a498e269c68ad3a85b00511dd47240c25bd1b16804c12cc3bd0"
  license "MIT"
  head "https://github.com/context-labs/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93e5baab5a142b7132de086e25d536392caae9c7f64ab0ad45d3cf31c304743b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e7f8496ad4c4551a1ec0b793be69e6cf531ac19b088c2311d8d692a949bbabf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed46cd535abd6b54a2f098b5682f50547b3de591d21eb60c3ef37ccb38fa773f"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def caveats
    <<~EOS
      mactop requires root privileges, so you will need to run `sudo mactop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end