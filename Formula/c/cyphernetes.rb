class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https:cyphernet.es"
  url "https:github.comAvitalTamircyphernetesarchiverefstagsv0.14.1.tar.gz"
  sha256 "b2c5d9689756c421cc3d698077d748be0c8c51cda084a07cba27c1c316009155"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86b11f1233c7261c21aaae69d9912583f1be70f9e63a67a1d0db41fa88a80046"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86b11f1233c7261c21aaae69d9912583f1be70f9e63a67a1d0db41fa88a80046"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86b11f1233c7261c21aaae69d9912583f1be70f9e63a67a1d0db41fa88a80046"
    sha256 cellar: :any_skip_relocation, sonoma:        "0340a511753fe88e309de8c716842af30284527783c721ebb92e76649cd505dc"
    sha256 cellar: :any_skip_relocation, ventura:       "0340a511753fe88e309de8c716842af30284527783c721ebb92e76649cd505dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67cb9bd965798fec68bc1c7543bc78af2895976ace95e9cf552830e69813a0a8"
  end

  depends_on "go" => :build
  depends_on "goyacc" => :build

  def install
    system "make", "operator-manifests", "gen-parser"
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcyphernetes"

    generate_completions_from_executable(bin"cyphernetes", "completion")
  end

  test do
    output = shell_output("#{bin}cyphernetes query 'MATCH (d:Deployment)->(s:Service) RETURN d'", 1)

    assert_match("Error getting current context:  current context  does not exist in kubeconfig", output)
  end
end