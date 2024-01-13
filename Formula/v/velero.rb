class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https:velero.io"
  url "https:github.comvmware-tanzuveleroarchiverefstagsv1.12.3.tar.gz"
  sha256 "801a4fba67f708b05d1240f836d39290312d7b741dd65925233acd6b5fd37ce5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02675055fc9e61552a8731390efde7872212f8013a783160b066fb01290b83c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "230640469ff6bdad047a9537ffe20a646abbd5f906221c6fb1ba112115791c36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3177463f93b18d78f96e923089cd869643c3aaf03e4f957baacf84dc65cefeea"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9b9c6ba13ff8d229bbdf120426a3c0f7d334996235922f22b6a5ecb73743efd"
    sha256 cellar: :any_skip_relocation, ventura:        "91b92b482557a1f4cb279ece4af1cf809ac76c57b29c72cc528f6f816add30fe"
    sha256 cellar: :any_skip_relocation, monterey:       "882ef6d6e7dafd3cfde1aef4e3041099472c72abb94357a744ac86f09f6df056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57c8cad7cd56f8e2be605bcb80d0367f64c552fd615696477e8da84b8f575340"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comvmware-tanzuveleropkgbuildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-installsuffix", "static", ".cmdvelero"

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