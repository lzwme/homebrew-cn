class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https:www.talos.dev"
  url "https:github.comsiderolabstalosarchiverefstagsv1.10.1.tar.gz"
  sha256 "d7bcd4a43a01c8608468a48719cd1c2a3ea9b9e8456f637378aaa6fd79723dab"
  license "MPL-2.0"
  head "https:github.comsiderolabstalos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fafaa85b25329bdd416b26a2b1663908eda26b2fb76b49564315223e1049421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "586e1e8e8c4e2205c9a05705611c13712711d6c542be5ba55b871043932773eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c968b2a4dec4894b325aeb1c0778a1542d9f407268011a3449badff21be143f"
    sha256 cellar: :any_skip_relocation, sonoma:        "56266f4c294fcba15af2963f1ea7347ecf9e7273119cfa3cc101e750bde71507"
    sha256 cellar: :any_skip_relocation, ventura:       "611148d827fda896746b585baa2e8772232327e3f2e8b015bf2e462f8946f8d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1c97980d67bc558407c29f2f550c7fe2ceb22a2ea9104fcd0db678118d14817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "275da0c1f4e7889211ac1257f1af77a2b64fdd6bc27baba36eecaa734dda04d6"
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