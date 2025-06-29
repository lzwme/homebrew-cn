class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https:cyphernet.es"
  url "https:github.comAvitalTamircyphernetesarchiverefstagsv0.18.1.tar.gz"
  sha256 "afad8ccce87b1c6b46cb9921fe43631052306665879597ac7e06ac37868803ca"
  license "Apache-2.0"
  head "https:github.comAvitalTamircyphernetes.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f861ca93f8b89ca0c2cf04c9b41fe8e401a9770e2c342eb7d76b6bf167921a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f861ca93f8b89ca0c2cf04c9b41fe8e401a9770e2c342eb7d76b6bf167921a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f861ca93f8b89ca0c2cf04c9b41fe8e401a9770e2c342eb7d76b6bf167921a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b78d8c34c3eb6809c1ecb822c5c253d12fb3ff0e004a51623ac8a787456e2c7"
    sha256 cellar: :any_skip_relocation, ventura:       "3b78d8c34c3eb6809c1ecb822c5c253d12fb3ff0e004a51623ac8a787456e2c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee7c25d99ada66a7fd5806e270b0cacc869619ffea7640d9d4e2137f776db16a"
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