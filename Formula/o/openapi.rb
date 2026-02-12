class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "ee1f6c0d18f1f2a42d401732d6b2075d90cfc4758115b3881e333adab2e13cd0"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54ea9d484493e10605d04776486ad0afdbdf5d78f0b1e58fc520cee4beefcaa2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54ea9d484493e10605d04776486ad0afdbdf5d78f0b1e58fc520cee4beefcaa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54ea9d484493e10605d04776486ad0afdbdf5d78f0b1e58fc520cee4beefcaa2"
    sha256 cellar: :any_skip_relocation, sonoma:        "19a93c52e49a48924f8043bdbd6633eea2121a75f28bbf8242675024fbc5993e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5733cf583244349c8914ad80786a683c650913fd252f79e4437197c889f4d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfda87d6b9c958826bcf34739b7ebe6f45036939441c45c7f147fc4a49e75ecf"
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