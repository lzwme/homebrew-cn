class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.7.3.tar.gz"
  sha256 "a238f98064524b94d5b3438a55f8ca3c936f27c29251ba5fb963f28a74127f34"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7afd99345a5ae193d020a7f5f1e388076e9071144e7603b8b8c617b5d85ae1cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50cf78ec4ba256e5cc8db6b9ee6a86f5115ed369bca211b9440045875631958d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "173eb741165a5960cee1bcf2f0b0b7264b89294aa7514f61354b9c794d40bce1"
    sha256 cellar: :any_skip_relocation, sonoma:         "37c0acdc04285fdd57d9f89fcff9487dba25e4081b225331d1f07047789e3a48"
    sha256 cellar: :any_skip_relocation, ventura:        "00fc1edb021b563bc0d2994f0dd242aef2031e468e011dcfc57971e8e5bbb005"
    sha256 cellar: :any_skip_relocation, monterey:       "9733b78bc135de2261c02f4a51ccaa0bb29b2e36bf52ec4c06cd767c054900c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7a279ebe0639de7085438eeb9f85b13fb2797c9f2088db2fb3e6e97fac6c872"
  end

  depends_on "go" => :build

  def install
    cd "cyctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X github.comcyclops-uicycops-cyctlcommon.CliVersion=#{version}")
    end
  end

  test do
    assert_match "cyctl version #{version}", shell_output("#{bin}cyctl --version")

    (testpath".kubeconfig").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http:127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    assert_match "Error from server (NotFound)", shell_output("#{bin}cyctl delete templates deployment.yaml 2>&1")
  end
end