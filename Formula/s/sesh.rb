class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https:github.comjoshmedeskisesh"
  url "https:github.comjoshmedeskisesharchiverefstagsv2.11.0.tar.gz"
  sha256 "9c9258187ee101c2aabd045451090873a6fbd3ebf5b5479b06ffa8ea9c5b69e2"
  license "MIT"
  head "https:github.comjoshmedeskisesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fb6cf88399d33b39de5d265921070a5d113dbc8e2cde9c6343179f9c23a76be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fb6cf88399d33b39de5d265921070a5d113dbc8e2cde9c6343179f9c23a76be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5fb6cf88399d33b39de5d265921070a5d113dbc8e2cde9c6343179f9c23a76be"
    sha256 cellar: :any_skip_relocation, sonoma:        "72d67ae28e193ae357d6f97e680b67597501b93d54e57bac066fbbd78f4c5c3d"
    sha256 cellar: :any_skip_relocation, ventura:       "72d67ae28e193ae357d6f97e680b67597501b93d54e57bac066fbbd78f4c5c3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "565835f59dbe2e6d128ffcc19a444c88964d26f2c5a517696b0fb4a6e1853d31"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}sesh --version")
  end
end