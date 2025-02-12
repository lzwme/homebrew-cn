class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.48.0.tar.gz"
  sha256 "8b453e6e9a3614bb879ccf619c0b4f08b372da395f59ec821799b9830eba2c87"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39f80aabfaddf0ed2a64337887d975186f99fb2212c031d59faa601763b9df43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39f80aabfaddf0ed2a64337887d975186f99fb2212c031d59faa601763b9df43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39f80aabfaddf0ed2a64337887d975186f99fb2212c031d59faa601763b9df43"
    sha256 cellar: :any_skip_relocation, sonoma:        "a664b240b0d0d7dc789a8447113067e8d679c2b63ccc16b9004498aed9e02576"
    sha256 cellar: :any_skip_relocation, ventura:       "a664b240b0d0d7dc789a8447113067e8d679c2b63ccc16b9004498aed9e02576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57f7dc197340e249776df366f4eb1b8da681b006a8d82e2d1cbb423a545c8c56"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comekristenaws-nukev#{version.major}pkgcommon.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

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