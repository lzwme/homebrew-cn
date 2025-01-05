class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https:cyphernet.es"
  url "https:github.comAvitalTamircyphernetesarchiverefstagsv0.15.0.tar.gz"
  sha256 "42a5ced7ddb8e8ad31cf3d87aecc41c4d597cd769c0b7194946cdfed3b70daf2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c03c8a70d79210e1aa7abb4ff8d3c7ede44668fe69df1f13740abab9e07ecb19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c03c8a70d79210e1aa7abb4ff8d3c7ede44668fe69df1f13740abab9e07ecb19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c03c8a70d79210e1aa7abb4ff8d3c7ede44668fe69df1f13740abab9e07ecb19"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d1be25dd4cda00250f1f69ffd08e184dc7503be1925304e061fa5b4ca8d0dbf"
    sha256 cellar: :any_skip_relocation, ventura:       "8d1be25dd4cda00250f1f69ffd08e184dc7503be1925304e061fa5b4ca8d0dbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d3ecea24c863c03649d6a7532baa31cd57e8832e252e414b49a288e34bfca8d"
  end

  depends_on "go" => :build

  def install
    system "make", "operator-manifests"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), ".cmdcyphernetes"

    generate_completions_from_executable(bin"cyphernetes", "completion")
  end

  test do
    output = shell_output("#{bin}cyphernetes query 'MATCH (d:Deployment)->(s:Service) RETURN d'", 1)
    assert_match("Error getting current context:  current context  does not exist in kubeconfig", output)

    assert_match version.to_s, shell_output("#{bin}cyphernetes version")
  end
end