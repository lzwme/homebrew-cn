class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https:docs.doppler.comdocs"
  url "https:github.comDopplerHQcliarchiverefstags3.72.1.tar.gz"
  sha256 "5885361ea19967842b13c7006f22be6bcfd7c0acbc78334b1bf92ed81816eaeb"
  license "Apache-2.0"
  head "https:github.comDopplerHQcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0edea4ed6fbcbd23accf0cb37154bbbdb221b062a46489d5f9b0c2e582eaa79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0edea4ed6fbcbd23accf0cb37154bbbdb221b062a46489d5f9b0c2e582eaa79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0edea4ed6fbcbd23accf0cb37154bbbdb221b062a46489d5f9b0c2e582eaa79"
    sha256 cellar: :any_skip_relocation, sonoma:        "0086d1fb6d6bbdaaa67fba352518eb72c1da642b907a8dc829cbb77c52bd3967"
    sha256 cellar: :any_skip_relocation, ventura:       "0086d1fb6d6bbdaaa67fba352518eb72c1da642b907a8dc829cbb77c52bd3967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4947b7ec6c9afeb25f7f6f832a9ed66e0ce1aa4090ea3d6ef91d3ef0d2fa7e92"
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