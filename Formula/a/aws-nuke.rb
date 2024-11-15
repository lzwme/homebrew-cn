class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nuke.git",
      tag:      "v3.29.6",
      revision: "a0558818cf27ec785b9f9690ec361e8ce26001e2"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dbc3da0f5cb682cd92bab49f7bce8de34664cf522a1870b82e33e56c5466792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dbc3da0f5cb682cd92bab49f7bce8de34664cf522a1870b82e33e56c5466792"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dbc3da0f5cb682cd92bab49f7bce8de34664cf522a1870b82e33e56c5466792"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab7f78837f395500948f19d2d0d515dfb647275cefedbaf1b4971f4a1644d702"
    sha256 cellar: :any_skip_relocation, ventura:       "ab7f78837f395500948f19d2d0d515dfb647275cefedbaf1b4971f4a1644d702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db6922f26d19b69039e6bfbe308b0847d57899fe270827dbc4e22a6315bf767b"
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