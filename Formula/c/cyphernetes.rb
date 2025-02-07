class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https:cyphernet.es"
  url "https:github.comAvitalTamircyphernetesarchiverefstagsv0.16.0.tar.gz"
  sha256 "be4929cf4930c8e766ab36164e2645664a39407c6fd6709f708be9de8ff45094"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f91cbea3a004a1363a26d4e1c9c48f35d8131d9bb456e5ff25af319bbf956a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f91cbea3a004a1363a26d4e1c9c48f35d8131d9bb456e5ff25af319bbf956a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f91cbea3a004a1363a26d4e1c9c48f35d8131d9bb456e5ff25af319bbf956a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "880fc2315cdce045bf20bc16992f2f129c48eb9a4b47b62aa0e1d6a9bc601078"
    sha256 cellar: :any_skip_relocation, ventura:       "880fc2315cdce045bf20bc16992f2f129c48eb9a4b47b62aa0e1d6a9bc601078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4925ec5ea32390b1f62ef27c4928279a5b685d7a2122addd0a08ca362e571ca0"
  end

  depends_on "go" => :build

  def install
    system "make", "operator-manifests"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), ".cmdcyphernetes"

    generate_completions_from_executable(bin"cyphernetes", "completion")
  end

  test do
    output = shell_output("#{bin}cyphernetes query 'MATCH (d:Deployment)->(s:Service) RETURN d' 2>&1", 1)
    assert_match("Error creating provider:  failed to create config: invalid configuration", output)

    assert_match version.to_s, shell_output("#{bin}cyphernetes version")
  end
end