class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.10.0.tar.gz"
  sha256 "dbd10c95c903729d9605cac8fe713b96f5d1a11f24a526fef99e65cafbc70fb9"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "783811b1f779d461d3389a122db8e015f11f8f35d6b88596965d44eb0a9bc5f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "783811b1f779d461d3389a122db8e015f11f8f35d6b88596965d44eb0a9bc5f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "783811b1f779d461d3389a122db8e015f11f8f35d6b88596965d44eb0a9bc5f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "281d43f5e69e60389ec9204f5eac6a3984505aa27de978a057a82732feae5a09"
    sha256 cellar: :any_skip_relocation, ventura:        "281d43f5e69e60389ec9204f5eac6a3984505aa27de978a057a82732feae5a09"
    sha256 cellar: :any_skip_relocation, monterey:       "281d43f5e69e60389ec9204f5eac6a3984505aa27de978a057a82732feae5a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a9a03bda0fcacd68056dde6786c2fe23b60c6fca434e3260f1635b836559e67"
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