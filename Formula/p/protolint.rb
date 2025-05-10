class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https:github.comyoheimutaprotolint"
  url "https:github.comyoheimutaprotolintarchiverefstagsv0.55.1.tar.gz"
  sha256 "5d58dc9460dc6e7712a92e154f3d539f3ec5516577e43f4ae44490ee86549276"
  license "MIT"
  head "https:github.comyoheimutaprotolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f48da6ff3aa324ab2c175701f5e12c98399421e2265926c696bf41720f462c42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f48da6ff3aa324ab2c175701f5e12c98399421e2265926c696bf41720f462c42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f48da6ff3aa324ab2c175701f5e12c98399421e2265926c696bf41720f462c42"
    sha256 cellar: :any_skip_relocation, sonoma:        "890c2a21455f3940d838da86993ed3bc8a79c954af28a63efe1295708c1491da"
    sha256 cellar: :any_skip_relocation, ventura:       "890c2a21455f3940d838da86993ed3bc8a79c954af28a63efe1295708c1491da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c013b5b485d1b8a8d4c852cb44472b0a8993b754a8a519df7990b2d15f75ae93"
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