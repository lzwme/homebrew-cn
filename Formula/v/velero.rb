class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https:velero.io"
  url "https:github.comvmware-tanzuveleroarchiverefstagsv1.15.0.tar.gz"
  sha256 "60519b4412217df43fabceb081d12a1e6946451e9e19e98329ae06ef094b131d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6e745d1d8d7918875b381b1b02b6413950eb2e20cdd803e047c30c1ec456e30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6e745d1d8d7918875b381b1b02b6413950eb2e20cdd803e047c30c1ec456e30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6e745d1d8d7918875b381b1b02b6413950eb2e20cdd803e047c30c1ec456e30"
    sha256 cellar: :any_skip_relocation, sonoma:        "d819d4bcb780e9f1fb355fe5157b4ad90477e29a773dbbd7da73012ce678fce8"
    sha256 cellar: :any_skip_relocation, ventura:       "d819d4bcb780e9f1fb355fe5157b4ad90477e29a773dbbd7da73012ce678fce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6076fa8e959d2be3a633e9184f992f4da674748e0fbe8ab2a65e0763443b42aa"
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