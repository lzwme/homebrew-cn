class Grizzly < Formula
  desc "Command-line tool for managing and automating Grafana dashboards"
  homepage "https:grafana.github.iogrizzly"
  url "https:github.comgrafanagrizzlyarchiverefstagsv0.4.7.tar.gz"
  sha256 "1c577c444ea7ad58fbb4500fe8c49a9b80f484be686db48feebe4fbe76591ed7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "22b70a3f69b106bc9cba3a42ada3ed78b4f48817191387efb1b5958afde42b6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6552f7e86999cbacfd3adcb58d5602c3f4bce716a6ce7b0fc01b95953a75de90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6552f7e86999cbacfd3adcb58d5602c3f4bce716a6ce7b0fc01b95953a75de90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6552f7e86999cbacfd3adcb58d5602c3f4bce716a6ce7b0fc01b95953a75de90"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc82d70614867c5be7e756b0f7032930f0f5e17737be7e89242703fedafb6012"
    sha256 cellar: :any_skip_relocation, ventura:        "fc82d70614867c5be7e756b0f7032930f0f5e17737be7e89242703fedafb6012"
    sha256 cellar: :any_skip_relocation, monterey:       "fc82d70614867c5be7e756b0f7032930f0f5e17737be7e89242703fedafb6012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a95b5cc0bf79faf4f38ca26250c55a57cc47b4934e5af910a4efc76cb1a4ca2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"grr"), ".cmdgrr"
  end

  test do
    sample_dashboard = testpath"dashboard_simple.yaml"
    sample_dashboard.write <<~EOS
      apiVersion: grizzly.grafana.comv1alpha1
      kind: Dashboard
      metadata:
        folder: sample
        name: prod-overview
      spec:
        schemaVersion: 17
        tags:
          - templated
        timezone: browser
        title: Production Overview
        uid: prod-overview
    EOS

    assert_match "prod-overview", shell_output("#{bin}grr list #{sample_dashboard}")

    assert_match version.to_s, shell_output("#{bin}grr --version 2>&1")
  end
end