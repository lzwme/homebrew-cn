class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https:woodpecker-ci.org"
  url "https:github.comwoodpecker-ciwoodpeckerarchiverefstagsv3.2.0.tar.gz"
  sha256 "0bdc1f321cdd89e6781694913eea012d378ab36085ededa7487cc51a7b07f50d"
  license "Apache-2.0"
  head "https:github.comwoodpecker-ciwoodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c72a6309bff3716f41b77f946093261bdb1e81aa0b5d9d7ef9d89cdbcc40870"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c72a6309bff3716f41b77f946093261bdb1e81aa0b5d9d7ef9d89cdbcc40870"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c72a6309bff3716f41b77f946093261bdb1e81aa0b5d9d7ef9d89cdbcc40870"
    sha256 cellar: :any_skip_relocation, sonoma:        "604744ebc31a21ead7a2c2a95ea825a1058e4b9d0cc1126734f7136ad2735fb0"
    sha256 cellar: :any_skip_relocation, ventura:       "604744ebc31a21ead7a2c2a95ea825a1058e4b9d0cc1126734f7136ad2735fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eaea28d79717697b71197812c0ede91f7772a9730ff75c154a9d142638a461f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.orgwoodpeckerv#{version.major}version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"
  end

  test do
    output = shell_output("#{bin}woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not set up", output

    output = shell_output("#{bin}woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}woodpecker-cli --version")
  end
end