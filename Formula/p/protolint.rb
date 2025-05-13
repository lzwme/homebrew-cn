class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https:github.comyoheimutaprotolint"
  url "https:github.comyoheimutaprotolintarchiverefstagsv0.55.2.tar.gz"
  sha256 "95130aa86fb21515d29fe4b2d31dcba873f12ac490159b1cad5892363b0df636"
  license "MIT"
  head "https:github.comyoheimutaprotolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e54109fa4b9025a5a3a389e35634b4700308cdcc49b9bc71e45f662b93539d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e54109fa4b9025a5a3a389e35634b4700308cdcc49b9bc71e45f662b93539d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e54109fa4b9025a5a3a389e35634b4700308cdcc49b9bc71e45f662b93539d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c9d44c414fda494a75012380edc17efa7bac3a496566be709c0fadaa6856b24"
    sha256 cellar: :any_skip_relocation, ventura:       "5c9d44c414fda494a75012380edc17efa7bac3a496566be709c0fadaa6856b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56a84caa14100c3ea73f87f180fb0d4ab8b38a3428fa5794715b1bdf7a6d3663"
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