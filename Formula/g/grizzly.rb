class Grizzly < Formula
  desc "Command-line tool for managing and automating Grafana dashboards"
  homepage "https:grafana.github.iogrizzly"
  url "https:github.comgrafanagrizzlyarchiverefstagsv0.6.1.tar.gz"
  sha256 "bd5ed75eb4d7cf96cf58e58f7f134c9a4e803bf2237a8a8a1b9bc99176fc147d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "222d3c70d76f6ccdc610e1239c9350602574511542ff34d8c45cc6ee6481a082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "222d3c70d76f6ccdc610e1239c9350602574511542ff34d8c45cc6ee6481a082"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "222d3c70d76f6ccdc610e1239c9350602574511542ff34d8c45cc6ee6481a082"
    sha256 cellar: :any_skip_relocation, sonoma:        "e975a7122d07d2f3d9cba8fefd4be4598233d6b0877d902c386bc36c740601b4"
    sha256 cellar: :any_skip_relocation, ventura:       "e975a7122d07d2f3d9cba8fefd4be4598233d6b0877d902c386bc36c740601b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a7070c9babdae827a599c6f6fab27ade707b7026b104e807492a37b19af5f03"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comgrafanagrizzlypkgconfig.Version=#{version}"
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