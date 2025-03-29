class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https:docs.cloudfoundry.orgcf-cli"
  url "https:github.comcloudfoundrycliarchiverefstagsv8.12.0.tar.gz"
  sha256 "9344e0a954f245970a8d18b2cf80d404b9b26362fb80b8a329afda718c13c80a"
  license "Apache-2.0"
  head "https:github.comcloudfoundrycli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?((?!9\.9\.9)\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8afc95118b153f89df5c68af81152077b53223e4aa587ea20ce890d149446820"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8afc95118b153f89df5c68af81152077b53223e4aa587ea20ce890d149446820"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8afc95118b153f89df5c68af81152077b53223e4aa587ea20ce890d149446820"
    sha256 cellar: :any_skip_relocation, sonoma:        "e53e922edc94f1e1411ec8d4a044cf2fce81db2b9e7ea563047c270d0aa30ea5"
    sha256 cellar: :any_skip_relocation, ventura:       "e53e922edc94f1e1411ec8d4a044cf2fce81db2b9e7ea563047c270d0aa30ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c46220d3afc2f2c22c684308c958c0a62f98507ce1039fc1fc0e87f69a20c145"
  end

  depends_on "go" => :build

  conflicts_with "cf", because: "both install `cf` binaries"

  def install
    ldflags = %W[
      -s -w
      -X code.cloudfoundry.orgcliversion.binaryVersion=#{version}
      -X code.cloudfoundry.orgcliversion.binarySHA=#{tap.user}
      -X code.cloudfoundry.orgcliversion.binaryBuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"cf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cf --version")

    expected = OS.linux? ? "Request error" : "lookup brew: no such host"
    assert_match expected, shell_output("#{bin}cf login -a brew 2>&1", 1)
  end
end