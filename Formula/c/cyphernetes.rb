class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https:cyphernet.es"
  url "https:github.comAvitalTamircyphernetesarchiverefstagsv0.18.0.tar.gz"
  sha256 "eaa8c9e207cf216883b173c009cbc82eccdc4f6e81be9c9d0ff970be7e17e287"
  license "Apache-2.0"
  head "https:github.comAvitalTamircyphernetes.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "299db3931e982645927b03e147cbbca6249735b65ce0110037b46f40811cdb40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "299db3931e982645927b03e147cbbca6249735b65ce0110037b46f40811cdb40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "299db3931e982645927b03e147cbbca6249735b65ce0110037b46f40811cdb40"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c5101a64bf646fed5b79e09466e5af46d641ce289269fc797f4a5c667f574bc"
    sha256 cellar: :any_skip_relocation, ventura:       "7c5101a64bf646fed5b79e09466e5af46d641ce289269fc797f4a5c667f574bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d30598a6d0ccdca7c157835c802057af8c15614062d4a2a39718ed0858bbedcf"
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