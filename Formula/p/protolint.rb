class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https:github.comyoheimutaprotolint"
  url "https:github.comyoheimutaprotolint.git",
      tag:      "v0.47.0",
      revision: "c72c4ac3bd30e493cfeef5a627c468c7632515e8"
  license "MIT"
  head "https:github.comyoheimutaprotolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80765b0cfb15774bdaaf42e4459c4d31843337fc9995d09960eb3543e5212d24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5faf43aa0bc721ce4b3e196e81560af304e3865ac05e2ef2fd29bfd4e01e1815"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdd3c3f0902a6072ad7037fe4bce08d8d321064a12d5c7bd49225bd6eaf362a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5421369d9e4aa41e6a510fcc95bab6b176ace01a81f0f632ed4bb77eb9909061"
    sha256 cellar: :any_skip_relocation, ventura:        "31aa484d9607dc5b00601039a229c3f8f102214592a11d2751e039709ce67548"
    sha256 cellar: :any_skip_relocation, monterey:       "f7dbb404fcfb85a53105e0b6413c0d22249042c2c127ad6a5d53d7b52cb94b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24431202660e1437241b750876aa080203c88434ebd544f7d682b861a15437d0"
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