class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.6.2.tar.gz"
  sha256 "02ed62bec983a9937ec6decb4185c405c5a2da41adaa056b30c846d9161cf46e"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c5474e77d0e272daed4e3e2dd84d0bc5e3e8e61637b5de354c297e2bde22c82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e8263547ae547ac607efd8464f50560b8120780025023f0f68d6753b1e67aad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c09fcd6c55798a3b3d365e4e45b232abdfe1b397f3ea028b7492952ea760bf9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a60885c8ba77a7ed901f3a82653f522702e9e5565c3107ff3c32c3cc8354ae92"
    sha256 cellar: :any_skip_relocation, ventura:        "236cbf3b52be6ee20b8bc75421047c6c0e085598a8234a6a44b282084fc014af"
    sha256 cellar: :any_skip_relocation, monterey:       "18836736cefdbb1cffb78fd02dddec4fab2c3118d8b13d6742d2a3c1080d1acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4671995661a9d02e5eefddd142e23bf31d88c279400bffcfe96a20fac39c33b8"
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