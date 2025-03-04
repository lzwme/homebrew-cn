class Curlie < Formula
  desc "Power of curl, ease of use of httpie"
  homepage "https:github.comrscurlie"
  url "https:github.comrscurliearchiverefstagsv1.8.1.tar.gz"
  sha256 "0b90d359b94af1d32cb2d34607f2bee10200e2f6a35f55840472e78dab7ed6f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97885e654230197afb49fcbbe27e15b7938d1cd144d15149a1f9b2b585364e35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97885e654230197afb49fcbbe27e15b7938d1cd144d15149a1f9b2b585364e35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97885e654230197afb49fcbbe27e15b7938d1cd144d15149a1f9b2b585364e35"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa1c3af58c3196b7eccbc096fd8a8af0036044ad528e21ea35794ffbf79499dc"
    sha256 cellar: :any_skip_relocation, ventura:       "aa1c3af58c3196b7eccbc096fd8a8af0036044ad528e21ea35794ffbf79499dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee1ca8a2f3407b408bc2e4a8c94775872617198507e216d69997c462bb590264"
  end

  depends_on "go" => :build

  uses_from_macos "curl"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "httpbin.org",
      shell_output("#{bin}curlie -X GET httpbin.orgheaders 2>&1")
  end
end