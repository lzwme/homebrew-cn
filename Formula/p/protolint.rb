class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https:github.comyoheimutaprotolint"
  url "https:github.comyoheimutaprotolintarchiverefstagsv0.51.0.tar.gz"
  sha256 "fce29acc2c5bb274b71392986144287ec72f297dbbd3f15cb28ab4fa1a59c844"
  license "MIT"
  head "https:github.comyoheimutaprotolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13c9f07f40975593356fec752bfc63135d43ca4e5f8e92de8b9a72f6fd0856a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13c9f07f40975593356fec752bfc63135d43ca4e5f8e92de8b9a72f6fd0856a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13c9f07f40975593356fec752bfc63135d43ca4e5f8e92de8b9a72f6fd0856a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "72dab4f56a721964003953dec221857cf3cea80fc64540e34786019eccbd7552"
    sha256 cellar: :any_skip_relocation, ventura:       "72dab4f56a721964003953dec221857cf3cea80fc64540e34786019eccbd7552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e95f4a17cc967fec1159e83e1e35626158dda26ae2b483506cd100f31741d951"
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