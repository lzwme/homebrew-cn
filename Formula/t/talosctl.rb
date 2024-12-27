class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https:www.talos.dev"
  url "https:github.comsiderolabstalosarchiverefstagsv1.9.1.tar.gz"
  sha256 "5b24763a3c627d690eb054a61afecdd8978c54d0a51a21cee7525eb20add35a2"
  license "MPL-2.0"
  head "https:github.comsiderolabstalos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a230689f6b79d2176c3cfe7e45b74c8a973cb08f6954648bdd0b6be71cb81643"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "909424f7114faf7ca3e572d4581557665465e5a0bddbd15f74daa64b31e15e02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe2047c7384ebf9fb9fc64cb13fe04250223873d00ae736eadaec7162e44ee8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad045a4ed150eb058b0911d8822590a657ca9b0a0f1a55c8a866b1d968d74aee"
    sha256 cellar: :any_skip_relocation, ventura:       "b9c94f155fa807b0453159d95bf19477954cc2eab5510d6b8f3a81b80dd582f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91f876f22123884d3b43835b62145b4af79dc528c1df07565b8d5982cb469081"
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