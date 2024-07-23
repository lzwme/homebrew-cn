class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.8.3.tar.gz"
  sha256 "fd578389a206e8a810b252674423f08371e1977393f1a7d9cbaa2590658b12e3"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41a9b73161eb3cfd3cb0ecdaaddda3a00adb9fc1c9a7b6728e706e98c9dc413f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3d774ad06b83aadad846e74a9945f5df9bb9e3212f110fea94d60251b0e6c4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9945be3ea19e0f77fd0317e60a9747b01bb12bdfd09bbf191235d280b2e56f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b8aca4f03f30be423f30762b55b20a797a4c2e41c12ad219549f1e029ff38a2"
    sha256 cellar: :any_skip_relocation, ventura:        "6606a63c09d484a2ab34b1e1cc9a8327cfcda5ac089ccb1773b4ae2c64fad57a"
    sha256 cellar: :any_skip_relocation, monterey:       "556ffde98534a2f2b5fa04f6a961b8e9866d1db75b34dcacc65230d0ec0d8f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67e0996967166f85c73785e4f09dac43e2f8a157371f70f64ed567c9cb00ab4b"
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