class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nuke.git",
      tag:      "v3.30.0",
      revision: "674525d6a6e99bfba506a567a7715f89c8fccd03"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b70d7dafc340b075658091a01a108103f1bc943abfbf2df07f9bc8e4cff3c3a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b70d7dafc340b075658091a01a108103f1bc943abfbf2df07f9bc8e4cff3c3a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b70d7dafc340b075658091a01a108103f1bc943abfbf2df07f9bc8e4cff3c3a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f130b31bb9465147cf00a765e92b999a82b6468b2eee9a4db6e5bb8858fcb122"
    sha256 cellar: :any_skip_relocation, ventura:       "f130b31bb9465147cf00a765e92b999a82b6468b2eee9a4db6e5bb8858fcb122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "407a251cd2101fdc0bf19ac26d0c6abe139f82b0112edbf5affb375b45a4ef84"
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