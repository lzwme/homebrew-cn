class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "5c0c267ccd3b57e25e9a3be29730f95124f2b3011cf75d199fb2b77e8ba353c0"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0dda3073d27d6e7a2c5a2626e78e5d545012a8bf325e6cc9cf07ff370f69d05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42502f34c4a130515600ada79552b2f1e5f5cbe7c3d0ab9f491bdaeb95962e2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fa19ecb23142024b459765fcd28ffd0e03d02404226032f6a6afdbf841d827f"
    sha256 cellar: :any_skip_relocation, ventura:        "1c55c70f564e9dd521055bb979dafd3d33fa9c260e7eb1bc4b5e9562b1263fb8"
    sha256 cellar: :any_skip_relocation, monterey:       "ffdedb5e0bae9da1bf0018d630a5dedc3368b43ee4e510e5269b77892bb759e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "43c095d797c1ba0cff15442e9830a34d718436773f7605b6ddc9e10ce636a906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae27ba26d1ad734e17264e392ff3d32b9a0961364f3bdaac9a75002620d73563"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match "v#{version}", shell_output("#{bin}/kubefirst version")
  end
end