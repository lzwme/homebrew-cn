class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https:github.comyoheimutaprotolint"
  url "https:github.comyoheimutaprotolintarchiverefstagsv0.50.1.tar.gz"
  sha256 "a4d961f20b58092de3b6cb4c948c0b3a18b3e9b20d3aaad1b4957f743b278b2e"
  license "MIT"
  head "https:github.comyoheimutaprotolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9546afaa7897ae09f102719027c8a2bafb9532bd673ed486ca584c2fedb69ef4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6d1a94d83635a106e251e0a3542fc6c1b755511658d0185391f92a30a61378c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58b4cf58abc7998ba9ae38ef246cb3bb89c412159c86ff30d1a4b30d6921f99d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7e3d57a1db9e967980670ae19afb7d6361dd31e518d7de6feb1487198b36488"
    sha256 cellar: :any_skip_relocation, ventura:        "a11935c6a9e9bacf143956fc261ab2954fb4a12fc5bbf6bc19ba98d5aafeae55"
    sha256 cellar: :any_skip_relocation, monterey:       "11257c661ced1c11210372765a38d42622d81b76613653f1ec9fdc1dde1eeda3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d84e9127e383dfc661f5729a7395e39b2204f01d27ce6c6bdeef58c5310dc9bd"
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