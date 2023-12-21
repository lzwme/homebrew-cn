class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https:github.comyoheimutaprotolint"
  url "https:github.comyoheimutaprotolint.git",
      tag:      "v0.47.2",
      revision: "e8006c43e776fd69f2f729605c53a4ca032bacdd"
  license "MIT"
  head "https:github.comyoheimutaprotolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a94d21e6cc341e5a31b52f517d13d222c69fcd2f7ebc71fb6f49fb222f4782e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5cfe171d68b0bdce0d460d881d49b99c0dbd55c75e020b1c984757b5ffc16d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20e065d5a665a0960c43bb5ab165d62330b220c9d93071e321adf067b3a44654"
    sha256 cellar: :any_skip_relocation, sonoma:         "18071870ab2e4877dda269e2a009e331aaadebf0aa339e18c768c0f303b5d471"
    sha256 cellar: :any_skip_relocation, ventura:        "66cd72ab508383e5aabc6e989921b4f290aac29349a67999234dd582d6af56b0"
    sha256 cellar: :any_skip_relocation, monterey:       "b2a2c8d647d4645c2e6a7a142b358f95918d367c1b0cafdead64ae358997734c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "230a0c4f3364f1115b03e1ffddc366323c92901b855d89f6d1853728b7f68ff6"
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