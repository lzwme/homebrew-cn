class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https:www.talos.dev"
  url "https:github.comsiderolabstalosarchiverefstagsv1.8.4.tar.gz"
  sha256 "f611046299fda6e9838b70f6a05abf7de9f3d5dcade2ec1b1bd7618b27c33910"
  license "MPL-2.0"
  head "https:github.comsiderolabstalos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf3155c3b77d63173d6cf4c29e438f55af92f083c4b74846636b3b4e3633a44b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "499ac61dd10541bfbedcab3659a140ff0372c47bae9f672b0f14240f29878954"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f5addef6e56bce2856b10eb126cd12a2701ec6bf06b0f809acdba2d119f1bb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "27e0f0f8c9e45d04a77c66ef92f780893730fe618deba2eade9e5e6d3fb0bb3f"
    sha256 cellar: :any_skip_relocation, ventura:       "1572a172920be89b986bf8d81caa43b3a4fc600e2565ba48ed408c3e7f55aae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b77c8f6b004b9b3c6e02424e848da03ea3da38228ca5d77ab807893ba47587d1"
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