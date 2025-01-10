class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https:cyphernet.es"
  url "https:github.comAvitalTamircyphernetesarchiverefstagsv0.15.1.tar.gz"
  sha256 "304d80ee9c103bdcc0ceaf6337fd95cdb1f68f8fb5b834afe281c0acbe19d08d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bffa55278e32eddd337d18eeb47d14397fbb81a300db48a311fe415ba7cdd659"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bffa55278e32eddd337d18eeb47d14397fbb81a300db48a311fe415ba7cdd659"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bffa55278e32eddd337d18eeb47d14397fbb81a300db48a311fe415ba7cdd659"
    sha256 cellar: :any_skip_relocation, sonoma:        "d80fde28927f4799236015cede1a625f28b1ce9379fbeda8d25634692643deb5"
    sha256 cellar: :any_skip_relocation, ventura:       "d80fde28927f4799236015cede1a625f28b1ce9379fbeda8d25634692643deb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "175f13f46116d7a76d0494a28ffbe9745eab498851efef9f65bb4c7950fc7dd7"
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