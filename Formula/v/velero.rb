class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://ghproxy.com/https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "c79524f9f0c7fc4f6b70a0d001e6f31b9b5227577e65edeb2a1e581df262938c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6789df5fbfe7f41f1517e28b9a729c6f4ce6dbfd902a366ff17ca9ae15b8552"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f2df1a61788d5339a5e57e1a2bb171932afd7e684db965ea69ca42ee94a7d14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0cbdfc986f1b0658ec49f8eb505bb4c7816fe27bf5edfc9a3c64a399d746033"
    sha256 cellar: :any_skip_relocation, sonoma:         "583dfbbf0c08f7a1a34ddd1b443b49308297ba80f0fde90d57c1024867780d85"
    sha256 cellar: :any_skip_relocation, ventura:        "9a167f43041af12a231ce6448291d5979148dfb4633f24279a5104a08fc0353f"
    sha256 cellar: :any_skip_relocation, monterey:       "f0c866ebf84ef3530b3e3b22072efeb2e03c7004593087d44a128040a82d7ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd2c3cf809e6ead873f738e2000867bead3d0b58f0c01ef6c604cb925af5b94f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-installsuffix", "static", "./cmd/velero"

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