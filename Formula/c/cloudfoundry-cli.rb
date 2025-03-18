class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https:docs.cloudfoundry.orgcf-cli"
  url "https:github.comcloudfoundrycliarchiverefstagsv8.11.0.tar.gz"
  sha256 "a89826427c0e4dc273c191ae1a459a8a447ba9362ddb8da7d07d97c6e42d6823"
  license "Apache-2.0"
  head "https:github.comcloudfoundrycli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?((?!9\.9\.9)\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d990370cf12440f35a9305a6339e603609b84442c6ca7d9a1998e09f888aa1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d990370cf12440f35a9305a6339e603609b84442c6ca7d9a1998e09f888aa1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d990370cf12440f35a9305a6339e603609b84442c6ca7d9a1998e09f888aa1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "397226081d3ce1a0bbd85ef28e644726170ebece2033e5a8b0133fbe4781c8d4"
    sha256 cellar: :any_skip_relocation, ventura:       "397226081d3ce1a0bbd85ef28e644726170ebece2033e5a8b0133fbe4781c8d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83d32f1626b307d3c934d2317eda0c0bbafe4bbaeadd002c9a6fd04a25530045"
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