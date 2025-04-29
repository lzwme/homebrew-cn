class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https:github.comyoheimutaprotolint"
  url "https:github.comyoheimutaprotolintarchiverefstagsv0.54.0.tar.gz"
  sha256 "bf936e1502eb4b19385885148b74fa8096668962ab098e5dd64d517f7a33d83f"
  license "MIT"
  head "https:github.comyoheimutaprotolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4299ef878b391f2fbd05a8fa53523eeb4804d6ab509cacb8f589775ea2fe999c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4299ef878b391f2fbd05a8fa53523eeb4804d6ab509cacb8f589775ea2fe999c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4299ef878b391f2fbd05a8fa53523eeb4804d6ab509cacb8f589775ea2fe999c"
    sha256 cellar: :any_skip_relocation, sonoma:        "83af964dd89c694f2a58e571182acfbfb1fcaf46a2017ac9a73eafcf0177ed13"
    sha256 cellar: :any_skip_relocation, ventura:       "83af964dd89c694f2a58e571182acfbfb1fcaf46a2017ac9a73eafcf0177ed13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bab765e1859f63f0b7a489bb71db9ac4f21b319a7ddd1a386432f6f87bda524d"
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