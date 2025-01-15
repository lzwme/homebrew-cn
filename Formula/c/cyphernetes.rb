class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https:cyphernet.es"
  url "https:github.comAvitalTamircyphernetesarchiverefstagsv0.15.2.tar.gz"
  sha256 "6f75b0ffd3b479f8c4f52e4a70922894fdc18382e52d960e05047cb2fadbd7c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "220b46e99f9831415a9ebb574164bd7ac6f156aa8d8700be6faa2d0c29ae99cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "220b46e99f9831415a9ebb574164bd7ac6f156aa8d8700be6faa2d0c29ae99cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "220b46e99f9831415a9ebb574164bd7ac6f156aa8d8700be6faa2d0c29ae99cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cbd9d7fbbc1dcbd5075b55cac66baa10b5635951d5717bcb8b4683ab759ccd1"
    sha256 cellar: :any_skip_relocation, ventura:       "2cbd9d7fbbc1dcbd5075b55cac66baa10b5635951d5717bcb8b4683ab759ccd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d49d216a246d947c431d624b23c92394b6801ca14a24670c1cb97c90cf92ea7e"
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