class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.12.0.tar.gz"
  sha256 "98f8ebef38c0f2e9adfe3143b9da01d07bcbba59cbb4fe06827e0132cade94ab"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef6e028d6ea1fcce63b3d4ecee97f40f1f57b087ebd24448d141b9ac58f412fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef6e028d6ea1fcce63b3d4ecee97f40f1f57b087ebd24448d141b9ac58f412fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef6e028d6ea1fcce63b3d4ecee97f40f1f57b087ebd24448d141b9ac58f412fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ddc96823c733a62d2cf6748b11c821d701f8f5e77f8e42e3baa9c2e3a039ee4"
    sha256 cellar: :any_skip_relocation, ventura:       "4ddc96823c733a62d2cf6748b11c821d701f8f5e77f8e42e3baa9c2e3a039ee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9a4568601f32e49878c7ac9c3191841740f8d9dec8038597302cd085d8f991d"
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