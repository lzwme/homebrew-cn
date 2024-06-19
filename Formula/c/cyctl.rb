class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.7.1.tar.gz"
  sha256 "ef2b20711c3442974676c951cc48bd8d8127767dfebde0bafe6e57128383b64f"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11ee144b1d74bdd4276e81d9f11252c0e149fc3d8d1317f8b335cc5a91d3af7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2d0bd16521674ba2d32842ed13998d55be41045ad5687589d327721b7d181d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b3e01163fa3620b2116d088e1d2cbf2a69d0a2d64eb2484bc7327fa838093b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf5c93236acda7b9f59aa30c4b9a2e92032467a3bba19670209887ed154a3252"
    sha256 cellar: :any_skip_relocation, ventura:        "ad932f3b7600d687d03df6c73ee0928ce6b8598798c4baf8fb0f63937dfdd260"
    sha256 cellar: :any_skip_relocation, monterey:       "f8e0b0d343ddbc74969c613861a3725ba4186809850fdf7687c121d5da5cff01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fa615dc6a951834ba9abc98b88e0130dca8b0254fcae5d513b0daff67ba1c9a"
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