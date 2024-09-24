class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https:cyphernet.es"
  url "https:github.comAvitalTamircyphernetesarchiverefstagsv0.11.2.tar.gz"
  sha256 "ccece1ff5f870e50a702f20af76c3e38207aba6266dc86dcf05943c7b8d4841c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "911c18c6c67bc1fbb4ea7211fe96287a5433f4a76e5e892c853ab9d407abf677"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7df58b1d1ed9a557b5e0d40756c9a0238fea205ce8f2ef11470aeaba1afb6e71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a299453d6f361f5d2413c2259d9ce579f93c16fe21c01de0516b6740f5cc0eab"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a29ff8ef37dcf0899895b10819c7f4bccc10ab1ef8e62753a49e5ba393c9e37"
    sha256 cellar: :any_skip_relocation, ventura:       "f2908a6d373664bfa4accb66b9c2179c9bb5600912a719aea75435a4d3dc47c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ae54607a8b99700fae6e3623ada7f0108bdac50e24ce9fb2c3e7c2bbf0e71c4"
  end

  depends_on "go" => :build
  depends_on "goyacc" => :build

  def install
    system "make", "operator-manifests", "gen-parser"
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcyphernetes"

    generate_completions_from_executable(bin"cyphernetes", "completion")
  end

  test do
    output = shell_output("#{bin}cyphernetes query 'MATCH (d:Deployment)->(s:Service) RETURN d'")

    assert_match("Error creating QueryExecutor instance", output)
  end
end