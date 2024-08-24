class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https:fairwinds.com"
  url "https:github.comFairwindsOpsplutoarchiverefstagsv5.20.2.tar.gz"
  sha256 "94f7ccdcf17f5f160e457c1e5a7adaf16a3c5db8556864596e832deaef65f848"
  license "Apache-2.0"
  head "https:github.comFairwindsOpspluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f91dc7e304a3b84924ee4b3571cfee190272944ef763a220b8b0a058254c478f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f91dc7e304a3b84924ee4b3571cfee190272944ef763a220b8b0a058254c478f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f91dc7e304a3b84924ee4b3571cfee190272944ef763a220b8b0a058254c478f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bf2a546ce67b6a8e83744cbd4a97507d4f7657ed35d709938ac219531bffaf9"
    sha256 cellar: :any_skip_relocation, ventura:        "3bf2a546ce67b6a8e83744cbd4a97507d4f7657ed35d709938ac219531bffaf9"
    sha256 cellar: :any_skip_relocation, monterey:       "3bf2a546ce67b6a8e83744cbd4a97507d4f7657ed35d709938ac219531bffaf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "127005205e91300c5435afdde2d528c7888705bd5c37f4b40572e2b4dab62a19"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "cmdplutomain.go"
    generate_completions_from_executable(bin"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pluto version")
    assert_match "Deployment", shell_output("#{bin}pluto list-versions")

    (testpath"deployment.yaml").write <<~EOS
      apiVersion: extensionsv1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    EOS
    assert_match "homebrew-test", shell_output("#{bin}pluto detect deployment.yaml", 3)
  end
end