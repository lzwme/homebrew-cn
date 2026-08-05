class Dbxcli < Formula
  desc "Command-line tool for Dropbox users and team admins"
  homepage "https://github.com/dropbox/dbxcli"
  url "https://ghfast.top/https://github.com/dropbox/dbxcli/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "7c7f1cb46dec65492eecc4d1f78151b55ccd2c1fd9b289029f389cca2ea0ff6d"
  license "Apache-2.0"
  head "https://github.com/dropbox/dbxcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42f002e62e30c8ec97469b11eb99b1bb752cb840bc6b15c9e2211a7b5ae7183f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42f002e62e30c8ec97469b11eb99b1bb752cb840bc6b15c9e2211a7b5ae7183f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42f002e62e30c8ec97469b11eb99b1bb752cb840bc6b15c9e2211a7b5ae7183f"
    sha256 cellar: :any_skip_relocation, sonoma:        "669f0a01d487255f8f1db8c8187495c82b8e365b7c10b384f0ec287808a852e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f738f14bff2ac606c908baae1bfa8edacc744f48fcda001a0f9d1c4c085bfa26"
    sha256 cellar: :any,                 x86_64_linux:  "bc28d2c8008227616476bffaa477029bde5bb6a15d10256c743a6eb215aa2821"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"dbxcli", "completion")
  end

  test do
    ENV["DBXCLI_AUTH_FILE"] = testpath/"missing-auth.json"
    output = shell_output("#{bin}/dbxcli ls 2>&1", 2)
    assert_match "no saved Dropbox credentials", output
  end
end