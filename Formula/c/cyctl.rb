class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.18.2.tar.gz"
  sha256 "c6bd616b235dd3617c2078a42774bf4e0d13d435e3c06fe7899261c1dd136a31"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2766aa9f3b98f6d828b74918ab1e1fd0766c5baea9aab67c4e4b398bcc3afff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2766aa9f3b98f6d828b74918ab1e1fd0766c5baea9aab67c4e4b398bcc3afff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2766aa9f3b98f6d828b74918ab1e1fd0766c5baea9aab67c4e4b398bcc3afff"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b9f92757bee3e6f8f816c776ad6cf3fd2872dccd5171e46fcf123bdbe7dd6f7"
    sha256 cellar: :any_skip_relocation, ventura:       "6b9f92757bee3e6f8f816c776ad6cf3fd2872dccd5171e46fcf123bdbe7dd6f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a88a11cdf70ca0ca46ce2816891ae70ade3636e17cad46f5f74df2a4ca8b53d"
  end

  depends_on "go" => :build

  def install
    cd "cyctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X github.comcyclops-uicycops-cyctlcommon.CliVersion=#{version}")
    end
  end

  test do
    assert_match "cyctl version #{version}", shell_output("#{bin}cyctl --version")

    (testpath".kubeconfig").write <<~YAML
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
    YAML

    assert_match "Error from server (NotFound)", shell_output("#{bin}cyctl delete templates deployment.yaml 2>&1")
  end
end