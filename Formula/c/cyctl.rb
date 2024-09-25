class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.13.1.tar.gz"
  sha256 "959c59c6697379f89f4f5edb61fe3e882ad5463987166f72657491e262033dcb"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f9da7320474f11f80a1a4be4054711924926cb5aab166d942983f9226b50134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f9da7320474f11f80a1a4be4054711924926cb5aab166d942983f9226b50134"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f9da7320474f11f80a1a4be4054711924926cb5aab166d942983f9226b50134"
    sha256 cellar: :any_skip_relocation, sonoma:        "674a1ec44f90f9b23128ddae9cf110198c9357c4b91779e31da8bd184d91e4a6"
    sha256 cellar: :any_skip_relocation, ventura:       "674a1ec44f90f9b23128ddae9cf110198c9357c4b91779e31da8bd184d91e4a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f272e3db5d9bfd8b89391981a409fe17a34368e77cca01d16ca56776d8c808be"
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