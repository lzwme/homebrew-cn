class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https:github.comyoheimutaprotolint"
  url "https:github.comyoheimutaprotolintarchiverefstagsv0.49.1.tar.gz"
  sha256 "e7b9aedbb2afa02477e04d1a1b9c21735287d790acae7c64a891a57405681c88"
  license "MIT"
  head "https:github.comyoheimutaprotolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99c40b353b08506f4aba16f5154b2aba1e24f1e38e4edf7bc0bd3440b670d01d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2c8a8a18274e160579d149a6e30d48ccb365936f0800e8bb8f0b969775a2b4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6da293ec67b79d956fa64f515274239879c9aebae34de316de73f365b3c67b43"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffedd9af81d966568a4adac9d5ff722524889c479a9bc855331100263c30abce"
    sha256 cellar: :any_skip_relocation, ventura:        "bd47524093a8751572b44075fc054228da4fa504508f43e395f397f15375c7a5"
    sha256 cellar: :any_skip_relocation, monterey:       "e8dc19cd6866abf93ccdb35d3c4ea3e402ba496b988b28f40994fd5c6bd23e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d2927ffcdae159be966eb27cb2e3fe810da6a082b45f2d648d03620276168a5"
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