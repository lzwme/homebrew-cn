class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://ghfast.top/https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.8.44.tar.gz"
  sha256 "47259943e25be8d5b98e70188e34412451d523b1c100b0d214b0c714d398dece"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/ctlptl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8695380c3a5fa85d38fc375e58cd2f8f44d69bc601d9540b1bccad55071f6258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5477cc39499d5642a04ef246262a0a448026479aa8c5b1f0445a88bc9f396e97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35e1791ff8f1ff4ed8f0e55f50589d85589505f0aee19c232b1624b79c026e31"
    sha256 cellar: :any_skip_relocation, sonoma:        "43c8008112bde8e8ab8e5345925cbe1dfe8f19dc01a2bdc8e748a3ff863cdb47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ad5a5ca557399bde01998cb3f7427b8e2b883d634f3a63d09f99603785d0977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51c829e2de7142b924f4c33e97ac2986b32d969fe5be28eeb593a95c6d49a1db"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_empty shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end