class Grizzly < Formula
  desc "Command-line tool for managing and automating Grafana dashboards"
  homepage "https:grafana.github.iogrizzly"
  url "https:github.comgrafanagrizzlyarchiverefstagsv0.7.1.tar.gz"
  sha256 "81811b684ef1bddd3b7147c5095224552a0b35dc3ff210d10e6cbc5e12331160"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c00e5b79f192d86d855287c9abb183eede829f47d6892bfef011d0977fb45cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c00e5b79f192d86d855287c9abb183eede829f47d6892bfef011d0977fb45cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c00e5b79f192d86d855287c9abb183eede829f47d6892bfef011d0977fb45cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "679f770b4eff802b8e9b6eb199fb9ae076f14093ea58342fcc1752d43985415f"
    sha256 cellar: :any_skip_relocation, ventura:       "679f770b4eff802b8e9b6eb199fb9ae076f14093ea58342fcc1752d43985415f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1cd0d526f55b71f84e88c4bda49551c661b56f7dcace86fbbbb637a27fd4274"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comgrafanagrizzlypkgconfig.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"grr"), ".cmdgrr"
  end

  test do
    sample_dashboard = testpath"dashboard_simple.yaml"
    sample_dashboard.write <<~YAML
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
    YAML

    assert_match "prod-overview", shell_output("#{bin}grr list #{sample_dashboard}")

    assert_match version.to_s, shell_output("#{bin}grr --version 2>&1")
  end
end