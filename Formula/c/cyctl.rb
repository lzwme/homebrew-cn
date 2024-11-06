class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.15.2.tar.gz"
  sha256 "326c3bdc327d739f06c8baf546669e1135360aa07b01447751be58ed291549c3"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "030130785d1a2d2e7de32b8de0668d39f3430ffd68b4f76f94f2ab6467a55c81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "030130785d1a2d2e7de32b8de0668d39f3430ffd68b4f76f94f2ab6467a55c81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "030130785d1a2d2e7de32b8de0668d39f3430ffd68b4f76f94f2ab6467a55c81"
    sha256 cellar: :any_skip_relocation, sonoma:        "264d5cd241fdf6233f106164279fbb0ade615aecbe0216b148d12a5707afbec7"
    sha256 cellar: :any_skip_relocation, ventura:       "264d5cd241fdf6233f106164279fbb0ade615aecbe0216b148d12a5707afbec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08c39d5241092e6eaa1c3b89e29992929f857980cb6f27d552e0cadb7c882d79"
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