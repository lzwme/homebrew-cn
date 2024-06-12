class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.6.5.tar.gz"
  sha256 "aa3d0a5cf9130d9ce9bad65562c4677899a8a07ddb5bf707dc478f2500162890"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29e02ef03f482b90dbc472ced0045701c4133ab43074db7e6cb855d9a6821acf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4b39cc05f516b0c04d7245bb350058ced6e7ddc0e0bb818db00af4d86af366d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74bd91f2e8357729fb018528561d4eb9fdcbad6c53c9d3dd13c11e445da1d300"
    sha256 cellar: :any_skip_relocation, sonoma:         "66974cfe6e71a0439c96cb8cd8bbd4b703645613699e09983176df3aa77b1ae9"
    sha256 cellar: :any_skip_relocation, ventura:        "a0d5afbcaf931d69b7db11f499d61f3fbd9abd215b3e8fd403d2be9decbccb68"
    sha256 cellar: :any_skip_relocation, monterey:       "2d35db6b1df2cb78e031db07c770b915d73974f84f3c3715cd60b3688f988feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b44e06c766e07b44bae143096501d05cd6a99699fe906b33f89a321dafaee7f"
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