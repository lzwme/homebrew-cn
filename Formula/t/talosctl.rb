class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https:www.talos.dev"
  url "https:github.comsiderolabstalosarchiverefstagsv1.10.2.tar.gz"
  sha256 "57edde4242397dfdff51a698229f7f1d8b5fa73c153ec7211b2c3d484c468ed4"
  license "MPL-2.0"
  head "https:github.comsiderolabstalos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56324ebe2e144adb4cbda2e0c9fb0c93b9abee9a37237b69885e8ffc36a78178"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e603bcf8679a26fbef7a546c2a239af08a61ff518cbc6ac17e75d47dc0ee4e8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fd299692b36f24b5368b5eaafaf35b128e52b0a4bbc7028742582152550e956"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0ff74597c387cd3409e57e290e9f6bddbe5f18a0d3d015a0ff3d4c94133bb15"
    sha256 cellar: :any_skip_relocation, ventura:       "1ed1d58519252c412182ceed5c37af8a18014eecfb9285e399bd45bdf805a406"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18e1b913708c79f8ec0ec08b59b64d74035e39325194e2538786daf1c4020c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcd307bda4833d35749b471e15bd09c4662a9b5307b23204b96c4530218612a9"
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