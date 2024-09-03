class Grizzly < Formula
  desc "Command-line tool for managing and automating Grafana dashboards"
  homepage "https:grafana.github.iogrizzly"
  url "https:github.comgrafanagrizzlyarchiverefstagsv0.4.6.tar.gz"
  sha256 "571c6c03dc8dd781f07c2c1201ffcc5d83600f9e65687a951ec7c0804a9a45df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c15c0347fbc53ac5f0b66a422f8c00c1582797cdba947569e093674ef507c40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c15c0347fbc53ac5f0b66a422f8c00c1582797cdba947569e093674ef507c40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c15c0347fbc53ac5f0b66a422f8c00c1582797cdba947569e093674ef507c40"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3784b1b1b9e0bf165c47013eac24cb4c915ac7943de50fbba479ca5b58cc961"
    sha256 cellar: :any_skip_relocation, ventura:        "a3784b1b1b9e0bf165c47013eac24cb4c915ac7943de50fbba479ca5b58cc961"
    sha256 cellar: :any_skip_relocation, monterey:       "a3784b1b1b9e0bf165c47013eac24cb4c915ac7943de50fbba479ca5b58cc961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d289622fb2f0060f8605c2e92343aa37553721a2d861ba7444f51bfcdff17ad2"
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