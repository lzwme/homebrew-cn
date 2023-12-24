class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https:github.comyoheimutaprotolint"
  url "https:github.comyoheimutaprotolint.git",
      tag:      "v0.47.3",
      revision: "744828f37b3fc0c7ebf5957e5c819767fc4c4e1c"
  license "MIT"
  head "https:github.comyoheimutaprotolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00b3536525bd1838f9c7a9d3d7acdfd54d729e67142768d9a4826c3854e541ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e42183303d3e924b5b6722e4b0ae0cd4d9b5b6c8ff2700f0e9dc64747a47dae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5dab14c2cb9c6203209e9bf0bd69b1b2cbb1cab6ebaa2a70e85a914a8298f2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ffb48691ca8e3eef290baa3d115d5dd29f1f437372a3558f6b20419f4ad82af"
    sha256 cellar: :any_skip_relocation, ventura:        "28e23c3b00fd21711a0f09ba1fd17795a7c26a7af49309aac2c069f506c7adf3"
    sha256 cellar: :any_skip_relocation, monterey:       "6092d042df8e37646c89368c4d8e6a0277e90da3b2d88ab1181d8bfeb0139aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c974b0c10cb7285c5d1d3abe2425a43e20fa73846b0056135fb524a1d619bbbc"
  end

  depends_on "go" => :build

  def install
    protolint_ldflags = %W[
      -s -w
      -X github.comyoheimutaprotolintinternalcmd.version=#{version}
      -X github.comyoheimutaprotolintinternalcmd.revision=#{Utils.git_head(length: 8)}
    ]
    protocgenprotolint_ldflags = %W[
      -s -w
      -X github.comyoheimutaprotolintinternalcmdprotocgenprotolint.version=#{version}
      -X github.comyoheimutaprotolintinternalcmdprotocgenprotolint.revision=#{Utils.git_head(length: 8)}
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