class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.8.2.tar.gz"
  sha256 "c1b0f8430592385e310e4be6f57ac5f168f7867247a020a62165b9f7159293de"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f96f949e385a0172c3bbd6a27c6fd94771f6f39513c6daa6f8b82f06f934f90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3319e0b81697339ce01e4488c6442b140fa47cc91ec3692a30c812da254092c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b43963d302fdb77716a1b73d612601862d8f73dac8f8c70a39ee5400c789119"
    sha256 cellar: :any_skip_relocation, sonoma:         "e20d83e26045dccaf70a618169031c7e35a910794c5dddd1143a703302728e52"
    sha256 cellar: :any_skip_relocation, ventura:        "345b9ea89c57501d8a5beefb49636160bb688b2cfb1134b3b80d35da0622425b"
    sha256 cellar: :any_skip_relocation, monterey:       "9b030d56c296c7aeb2a7f9dd91b27d38f76724a9a9aacd1d214de8ab39923fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7b8a6b8b06a37b5c164a7d6b5f8a5b8b36be0c19d6a874f07cb99041e28c669"
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