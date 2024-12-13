class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https:docs.doppler.comdocs"
  url "https:github.comDopplerHQcliarchiverefstags3.71.0.tar.gz"
  sha256 "96f88c156fb1dc5610ab08da7b21a0a7d72321c81ba93df3318c684749d4ee09"
  license "Apache-2.0"
  head "https:github.comDopplerHQcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9265ba84be180e38bf3bc9b7dcfcdaf28f8e252f809666e08c80cedd3f06bcd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9265ba84be180e38bf3bc9b7dcfcdaf28f8e252f809666e08c80cedd3f06bcd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9265ba84be180e38bf3bc9b7dcfcdaf28f8e252f809666e08c80cedd3f06bcd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "128c916d75b986098804419c8a0b1dc30a06d9cb8c7701981b7b2ef8b9016da1"
    sha256 cellar: :any_skip_relocation, ventura:       "128c916d75b986098804419c8a0b1dc30a06d9cb8c7701981b7b2ef8b9016da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e6639b53143325d88b05e149a7d2a5e247e0e07d3c29cc2dc77a91c1f5335a5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comDopplerHQclipkgversion.ProgramVersion=dev-#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}doppler --version")

    output = shell_output("#{bin}doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end