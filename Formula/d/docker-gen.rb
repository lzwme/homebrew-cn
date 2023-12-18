class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https:github.comnginx-proxydocker-gen"
  url "https:github.comnginx-proxydocker-genarchiverefstags0.10.7.tar.gz"
  sha256 "477cc1fac91e8908878b179df5eba34701b217dceb9760dc50652d9d5eb97de4"
  license "MIT"
  head "https:github.comnginx-proxydocker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63f61c8110f08a0ae4f5583c52c685731baf3412d08d29fd7112da39c46cbaf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17cf65f7e5639f89415f8fac4d93d54c48d6601d1a9980fb91d63a026db81e58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d785a2685e5e4de191465e93e4117ea9e15a2549f3db28cb4ea1c7a118624a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "527d1abf1d1e2ca3e9a988662f21631c7cca3fddcff4cc5430cc0f35e68c9f33"
    sha256 cellar: :any_skip_relocation, ventura:        "8fb2f11221f3cc2e9ffcf6faaba85bf7963cd8921bf71c56f9e9954c5af50deb"
    sha256 cellar: :any_skip_relocation, monterey:       "088ff43f883c43d289a046c1df5860994b12714f38d2921f984d73b4c34a89a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40aeeeb562b4e609d343b2d73c54e1994c6955462c5044d249de22e1f62738b5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmddocker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}docker-gen --version")
  end
end