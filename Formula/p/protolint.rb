class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https:github.comyoheimutaprotolint"
  url "https:github.comyoheimutaprotolintarchiverefstagsv0.55.3.tar.gz"
  sha256 "daaca5fa75bcdaf61ee9446aef8b7b6dbb23d4f4bb5da070e6e3f19f8c1c27e9"
  license "MIT"
  head "https:github.comyoheimutaprotolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a2169d22acd3f827f642eec006b9a8d0748b548a125a3a7d3966299db69dc5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a2169d22acd3f827f642eec006b9a8d0748b548a125a3a7d3966299db69dc5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a2169d22acd3f827f642eec006b9a8d0748b548a125a3a7d3966299db69dc5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6a6b72b0715b9e492c694de7e85db630475c25062aa4a30030481a3886b0f7d"
    sha256 cellar: :any_skip_relocation, ventura:       "f6a6b72b0715b9e492c694de7e85db630475c25062aa4a30030481a3886b0f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2899d00b972724e7385fb66bc6e212f48bc215787e3fa5090a524da326133e05"
  end

  depends_on "go" => :build

  def install
    protolint_ldflags = %W[
      -s -w
      -X github.comyoheimutaprotolintinternalcmd.version=#{version}
      -X github.comyoheimutaprotolintinternalcmd.revision=#{tap.user}
    ]
    protocgenprotolint_ldflags = %W[
      -s -w
      -X github.comyoheimutaprotolintinternalcmdprotocgenprotolint.version=#{version}
      -X github.comyoheimutaprotolintinternalcmdprotocgenprotolint.revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: protolint_ldflags), ".cmdprotolint"
    system "go", "build",
      *std_go_args(ldflags: protocgenprotolint_ldflags, output: bin"protoc-gen-protolint"),
      ".cmdprotoc-gen-protolint"

    pkgshare.install Dir["_exampleproto*.proto"]
  end

  test do
    cp_r Dir[pkgshare"*.proto"], testpath

    output = "[invalidFileName.proto:1:1] File name \"invalidFileName.proto\" " \
             "should be lower_snake_case.proto like \"invalid_file_name.proto\"."
    assert_equal output,
      shell_output("#{bin}protolint lint #{testpath}invalidFileName.proto 2>&1", 1).chomp

    output = "Quoted string should be \"other.proto\" but was 'other.proto'."
    assert_match output, shell_output("#{bin}protolint lint #{testpath}simple.proto 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}protolint version")
    assert_match version.to_s, shell_output("#{bin}protoc-gen-protolint version")
  end
end