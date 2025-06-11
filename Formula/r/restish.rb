class Restish < Formula
  desc "CLI tool for interacting with REST-ish HTTP APIs"
  homepage "https:rest.sh"
  url "https:github.comdanielgtaylorrestisharchiverefstagsv0.21.0.tar.gz"
  sha256 "9a73e743a78d6a28e2ff0dba53499b23c945c45f78b4a0ab3aa4b6283491de5d"
  license "MIT"
  head "https:github.comdanielgtaylorrestish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8aa4ddbae64dffa735470d8981074ea73c0d12c1f2029fcfc9e734a9f348ea7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c3d2dca304c360b00dbb8e93605b7655fbaa2dc3654e9ff1f069ed63bd1f08e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b22e5d04d229446fd76949b5683c18185ee979aa8285db31e2de5693e8a9d8fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d34179ef97dd275569cac439f24bbfaedfbbf8e087b6cfc7e9d76caf7a3cf75b"
    sha256 cellar: :any_skip_relocation, ventura:       "1eadc3f54a712bdd3eaef9d6c3b709dcd6e3952e115a7014cef918fc15b192fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "677209c2e2a6883004bfbb59a807e2206dd4bf5997715fbd7ae98decf24dcd72"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin"restish", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}restish --version")

    output = shell_output("#{bin}restish https:httpbin.orgjson")
    assert_match "slideshow", output

    output = shell_output("#{bin}restish https:httpbin.orgget?foo=bar")
    assert_match "\"foo\": \"bar\"", output
  end
end