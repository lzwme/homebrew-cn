class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https:www.talos.dev"
  url "https:github.comsiderolabstalosarchiverefstagsv1.10.4.tar.gz"
  sha256 "8357eca251cab6f7820aa111ed55bb4a8c9fb2c17473e843a0ec5221af14f7ed"
  license "MPL-2.0"
  head "https:github.comsiderolabstalos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a8fe64a3d438fe85625cf857fe667e987d99b4540de2beaf8c1301b2073a558"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94a079b36d7ebb34f274a830be9e8257a66f45275b597b8a452a6f63b2fc25d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e13aeb8d8cf900d35f4526d0badad69b2dfb1502a7f43d62bba7797209b2447"
    sha256 cellar: :any_skip_relocation, sonoma:        "376270d6f99a46eeee79d86668dbf576f7f10ae98bdb06db349b0920cb858ae5"
    sha256 cellar: :any_skip_relocation, ventura:       "95ed045b862c0417584cd83091cabe5bf87f44a3cdc980265d5e2897954a82ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6b0460331e6cd674bcef6f6f6f2b43be532e41ccf6219b4419a736567f9159f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e96bed96eb33144b3126574f20585dfc20dd8a08499f2e3937391e0450eabd8d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comsiderolabstalospkgmachineryversion.Tag=#{version}
      -X github.comsiderolabstalospkgmachineryversion.Built=#{time.iso8601}

    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtalosctl"

    generate_completions_from_executable(bin"talosctl", "completion")
  end

  test do
    # version check also failed with `failed to determine endpoints` for server config
    assert_match version.to_s, shell_output("#{bin}talosctl version 2>&1", 1)

    output = shell_output("#{bin}talosctl list 2>&1", 1)
    assert_match "error constructing client: failed to determine endpoints", output
  end
end