class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https:eprint.iacr.org2023296"
  url "https:github.comopenpubkeyopkssharchiverefstagsv0.6.0.tar.gz"
  sha256 "df86132ce42ba3ad4bb7b34584a1176a38d6243514a365d866f67a9f1536f67b"
  license "Apache-2.0"
  head "https:github.comopenpubkeyopkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49beea5fe70ad37de1567a2f36097923ae94bd5a26907c906fad7c89379b3c3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49beea5fe70ad37de1567a2f36097923ae94bd5a26907c906fad7c89379b3c3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49beea5fe70ad37de1567a2f36097923ae94bd5a26907c906fad7c89379b3c3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3f63fd99d661128895e755e5335fdb2a6f5efb1685edb0f38839435eb2aa920"
    sha256 cellar: :any_skip_relocation, ventura:       "f3f63fd99d661128895e755e5335fdb2a6f5efb1685edb0f38839435eb2aa920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a99fc32467379548b18d00237ae0aee713ad02638025d055c4b5bdfd1d857e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}opkssh --version")

    output = shell_output("#{bin}opkssh add brew brew brew 2>&1", 1)
    assert_match "Failed to add to policy", output
  end
end