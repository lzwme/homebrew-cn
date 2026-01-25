class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "ca02cd6e60ad805efe170edf393f17dd07cb87ae181913e841c50cffaa216f13"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42e40a4fc51d84efafd15dc99122ea0bf2e75638a1500f05b21c720f8f1eb46c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42e40a4fc51d84efafd15dc99122ea0bf2e75638a1500f05b21c720f8f1eb46c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42e40a4fc51d84efafd15dc99122ea0bf2e75638a1500f05b21c720f8f1eb46c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c1149a89058420e774b0b0af3fcea7bb1a1120dd9448f782a902a905ee61bd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce97a20eccade5115255482944e26fd00b15c5c947667d35755b45eae8e69d91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cf4a71cd582fec39ff85a87e8b8ff17529887063975f4c4a5ef191216e34c19"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end