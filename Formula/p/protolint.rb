class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https:github.comyoheimutaprotolint"
  url "https:github.comyoheimutaprotolintarchiverefstagsv0.55.5.tar.gz"
  sha256 "6d8a28c9da6769c362b9b75fbc4315888b943ab4fbeadc9813da609abab30b9e"
  license "MIT"
  head "https:github.comyoheimutaprotolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e39dbfffb1616fc2d53aeeaf302dae3923d0bbfb12af5d5682231898b1123e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e39dbfffb1616fc2d53aeeaf302dae3923d0bbfb12af5d5682231898b1123e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e39dbfffb1616fc2d53aeeaf302dae3923d0bbfb12af5d5682231898b1123e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0242fd129664a5b9d2594f7f6fbece1c509e006bb498b80d44da51871510ed1"
    sha256 cellar: :any_skip_relocation, ventura:       "f0242fd129664a5b9d2594f7f6fbece1c509e006bb498b80d44da51871510ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e984c2783fe3546c0bb4b57d408ee8aecb97a2e411dbeb10b3da75bf6dd72495"
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