class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://ghfast.top/https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "e0af83f193050c50068de7c77cb54dedd3aa773396369349b3cba08fa89aceed"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b824699a031129530752a82f2ccb757ea1c061371ef646d5a7931f8263a255eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bfb226399c32ab2b6c64b4be43537f6d6f190bfe1009c9f02ae9b09b06c8eae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bfb226399c32ab2b6c64b4be43537f6d6f190bfe1009c9f02ae9b09b06c8eae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bfb226399c32ab2b6c64b4be43537f6d6f190bfe1009c9f02ae9b09b06c8eae"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7d0683a5494c3f28f6427c46b5263c0270235a7e4c413f5ac8b33ed166b92cd"
    sha256 cellar: :any_skip_relocation, ventura:       "c7d0683a5494c3f28f6427c46b5263c0270235a7e4c413f5ac8b33ed166b92cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d30ac7f2cd6f3a1670d6937f9bdb8ceec08d751fe39cf40d9a991f97b268a26"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "-installsuffix", "static", "./cmd/velero"

    generate_completions_from_executable(bin/"velero", "completion")
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end