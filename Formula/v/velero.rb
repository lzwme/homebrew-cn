class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https:velero.io"
  url "https:github.comvmware-tanzuveleroarchiverefstagsv1.15.1.tar.gz"
  sha256 "769cf06c63c759f4a8254aef43f76c3a2c121d5abde30acd910a84ad15a286df"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7135a3895e4569056c1716823e9d3c66d002b1ada0dbc24d67f528744a194324"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7135a3895e4569056c1716823e9d3c66d002b1ada0dbc24d67f528744a194324"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7135a3895e4569056c1716823e9d3c66d002b1ada0dbc24d67f528744a194324"
    sha256 cellar: :any_skip_relocation, sonoma:        "436b89b82165f2c9add194e212c33a590273e7a407c19fa27947589e2662b73b"
    sha256 cellar: :any_skip_relocation, ventura:       "436b89b82165f2c9add194e212c33a590273e7a407c19fa27947589e2662b73b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdca4b41c65a47e88b78902a54100651c6534f55dc563bb5f122f0b6a35436ce"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comvmware-tanzuveleropkgbuildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "-installsuffix", "static", ".cmdvelero"

    generate_completions_from_executable(bin"velero", "completion")
  end

  test do
    output = shell_output("#{bin}velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}velero version --client-only 2>&1")
    system bin"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}velero client config get 2>&1")
  end
end