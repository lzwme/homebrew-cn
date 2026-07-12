class Rdap < Formula
  desc "Command-line client for the Registration Data Access Protocol"
  homepage "https://www.openrdap.org"
  url "https://ghfast.top/https://github.com/openrdap/rdap/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "19a6b1fe6c3335fa8bb48fb4c33ce56082e0ffdd24dd649745793613ab6c85cb"
  license "MIT"
  head "https://github.com/openrdap/rdap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a695a18ef38ae2f5ddc8e4400015cc04f6a3729dc3b8cb2e6446015daf5050c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a695a18ef38ae2f5ddc8e4400015cc04f6a3729dc3b8cb2e6446015daf5050c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a695a18ef38ae2f5ddc8e4400015cc04f6a3729dc3b8cb2e6446015daf5050c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fb1778bfa8d8d70dd45e44cd75d76d93b9923fc2a45e524b95fb2a14de7f0bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c3c05db5354528a8d974efc74a3bcd4a2f0264f5629e784e6dedd976cf781f5"
    sha256 cellar: :any,                 x86_64_linux:  "74befb3dedc1f9ee55d3c409e23a11a239dc43334f6da2dc5086357989a0cef8"
  end

  depends_on "go" => :build

  conflicts_with "icann-rdap", because: "icann-rdap also ships a rdap binary"

  def install
    ldflags = %W[
      -s -w
      -X github.com/openrdap/rdap.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/rdap"
  end

  test do
    # check version
    assert_match version.to_s, shell_output("#{bin}/rdap --help 2>&1", 1)

    # no localhost rdap server
    assert_match "No RDAP servers found for", shell_output("#{bin}/rdap -t ip 127.0.0.1 2>&1", 1)

    # check github.com domain on rdap
    output = shell_output("#{bin}/rdap github.com")
    assert_match "Domain Name: GITHUB.COM", output
    assert_match "Nameserver:", output
  end
end