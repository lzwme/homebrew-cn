class CloudProviderKind < Formula
  desc "Cloud provider for KIND clusters"
  homepage "https://github.com/kubernetes-sigs/cloud-provider-kind"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/cloud-provider-kind/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "f12d6650438776abd6745f5a1f061e15acb10a77476ac4c2387109d05233f617"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cloud-provider-kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "304f7e97da9f0e268909730eafc70139b8dd99bba27be1b068ae27aa156d1134"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afc5e9de8ed89265fd41b2afb4424ee12203bb8bc0cfc1ff9e5a26eb07a7de1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50844de15064d8e8c00f310a2116db9bd05e3936706d52e87d807a3fe6cfa75b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ffd1fd7cef253a5e8564eae3e3b6e86519823d48dc4ba43f094843eae298a7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24bb13b81fc2313d284c32674569df96f1d11eed1e3c4c579b20341afd85cd1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c30aba4804b6833987b320dd2f295a56ef6d2ad7cccfc48903b941b04cfe53e9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    status_output = shell_output("#{bin}/cloud-provider-kind 2>&1", 255)
    if OS.mac?
      # Should error out as requires root on Mac
      assert_match "Please run this again with `sudo`", status_output
    elsif OS.linux?
      # Should error out because without docker or podman
      assert_match "can not detect cluster provider", status_output
    end
  end
end