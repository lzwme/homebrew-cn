class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://ghproxy.com/https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.18.6.tar.gz"
  sha256 "a5be742d067d8a2f175aba26720f8c6c9ade364eac1764040e420771d32bbd19"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e943a44a36716633bfe9f8422fa4ef47b9a559ffab4c74b26fc41ba852ec76b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0323e94c8126f0b4c850f7dc1e99bc57477c27516f0cdee205a5004f789013c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9675792ce679c67dd3c71a6c1338ae4804986ddea76483efb17c8fc44654f4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f3ef40659bfabdcb3912050967c2362d4aefd2740d2717e894cea9795eefe5f"
    sha256 cellar: :any_skip_relocation, ventura:        "e27f5bd62cf6101f09e086651f7ea5540e4f4f68128c0516e0620407e1882f52"
    sha256 cellar: :any_skip_relocation, monterey:       "dd08bd06c926e0f9cc149df698c9c495c3f4db8fdd5dbc99ea18984762191a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca3c563e425b3f9754e85403d542a6d3224294bdec58ba5cadf9a04b4296afc2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~EOS
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    EOS
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end