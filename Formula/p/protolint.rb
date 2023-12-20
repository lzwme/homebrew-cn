class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https:github.comyoheimutaprotolint"
  url "https:github.comyoheimutaprotolint.git",
      tag:      "v0.47.1",
      revision: "f640d2220d33b97f80b859c23efea6b0bd6ff1aa"
  license "MIT"
  head "https:github.comyoheimutaprotolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afeeeb9c92cba8164c2380c7d9b4a345a346df1580dc3073db1086924e065f84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09ceff10777b0fd5608af44f3410fdbe4c2ea9816bdd726bbb03e66b7c6966ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "434ffdda5e46f5406d14b9aef0debaf186e4caf8afecd296c288f9354a6c3be4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c598e044c21a436bb062ffaa0435a069bc61355704e7d40789cdbd983a8cd83f"
    sha256 cellar: :any_skip_relocation, ventura:        "96541df8802a18289b51f220e2e51308f7a991cb00c34876bf2a0c9f8f204cba"
    sha256 cellar: :any_skip_relocation, monterey:       "e9b335f708917025a908978a1e146ba96ff7c8867d5ba30584bde787b6484a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fe5a636d3925013b1956854f5e5075fb77651fb2675331653d71eb51c42f0bf"
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