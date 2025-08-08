class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://ghfast.top/https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.22.3.tar.gz"
  sha256 "c34c6fe55dbdbd9ef1dbf15662dc14a65504e37fdbade41a36deb6d31183dcd3"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59fa6d481e261a720ea236320414869bdfed5cd0039796af418e4ff4169ccff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59fa6d481e261a720ea236320414869bdfed5cd0039796af418e4ff4169ccff1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59fa6d481e261a720ea236320414869bdfed5cd0039796af418e4ff4169ccff1"
    sha256 cellar: :any_skip_relocation, sonoma:        "095b5d218d2dd49fede38213820ca1551fcaadee5c0e1068760806df22913f44"
    sha256 cellar: :any_skip_relocation, ventura:       "095b5d218d2dd49fede38213820ca1551fcaadee5c0e1068760806df22913f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f60d3fe830ab2eaeca2f2999907a6f46861baec44182a55656874b1410a2aa4c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~YAML
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    YAML
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end