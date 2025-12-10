class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.14.0",
      revision: "cee1b0429e1db489e2f632f70c412143be55e926"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b63f9ef88abb6df326aff2b36fe9382a4fcfea9c098c8554afc84dc372032b61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b63f9ef88abb6df326aff2b36fe9382a4fcfea9c098c8554afc84dc372032b61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b63f9ef88abb6df326aff2b36fe9382a4fcfea9c098c8554afc84dc372032b61"
    sha256 cellar: :any_skip_relocation, sonoma:        "90ba14dec54237d99cdb5f8b2d6111b270dac2329c9a2ccc526681b0eb46abc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83a359e29a60019ac4a34ec478970451354569bcb153e045cae3d78ccb01886a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "845759d5c25579a99ed29b546b4bc4aff1c31f6a4fa7383f8f15260189235154"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end