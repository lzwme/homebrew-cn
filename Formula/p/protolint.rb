class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https:github.comyoheimutaprotolint"
  url "https:github.comyoheimutaprotolintarchiverefstagsv0.50.3.tar.gz"
  sha256 "f0555090c3b435a942ee3db80d63a862de9728a14ad3b831bc4445a1e824bf85"
  license "MIT"
  head "https:github.comyoheimutaprotolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "684bf1214a4d489b8d2cfa7bd6d7e37b42eeb41245afefacd0b2e5f6a04a7e14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "090e4e15eab3cbe1a31b8ddf61b023267b3423582ad83b0efc79e01596a56473"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d53eeab7d2bf5c1b7c94a0780e54eb099b597663eb6e6434fd4cd7e48c056cfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "638f81186a8917b1bc981bdcf4975c62b9bf4d36bcc49802e66e4a38bd34620f"
    sha256 cellar: :any_skip_relocation, ventura:        "d3d51f43f4372d00569424ba6ff91cd7bb79cf701cf6ceffb230d8c9f78efd91"
    sha256 cellar: :any_skip_relocation, monterey:       "88639fd2095ec4632f87075a2502a2814be44f78d408a9997c366c1be03c84b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "654c434496e5799077ab73b2401b3472666a8ea1123edddf13e2f0d200cd8665"
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