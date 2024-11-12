class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nuke.git",
      tag:      "v3.29.5",
      revision: "a3f1210863e65d48b74da1c302b15b0cc07c0d62"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b35a421331e56631b97cab7861da79525d61febcdd69f0584e03ee20656f252a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b35a421331e56631b97cab7861da79525d61febcdd69f0584e03ee20656f252a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b35a421331e56631b97cab7861da79525d61febcdd69f0584e03ee20656f252a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2858199b57cfdce4a13368e5de1ef302acf5c0d9fc4b0f76b6dd319bff3728d3"
    sha256 cellar: :any_skip_relocation, ventura:       "2858199b57cfdce4a13368e5de1ef302acf5c0d9fc4b0f76b6dd319bff3728d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5522d20f8c136afd0ae55e96a1212ca38a38e26e311b7b19b27c02fc0642df9a"
  end

  depends_on "go" => :build

  def install
    build_xdst="github.comekristenaws-nukev#{version.major}pkgcommon"
    ldflags = %W[
      -s -w
      -X #{build_xdst}.SUMMARY=#{version}
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags:)
    end

    pkgshare.install "pkgconfig"

    generate_completions_from_executable(bin"aws-nuke", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}aws-nuke run --config #{pkgshare}configtestdataexample.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}aws-nuke resource-types")
  end
end