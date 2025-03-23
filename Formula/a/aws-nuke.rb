class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.51.0.tar.gz"
  sha256 "4af211d760d9eaa9b863ba8a37866f319ddf60e23d47240ebc3947e20afbac25"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6616757bf3a192b414623d7d31da70cb2ed480ae4178be6f092791c958b9135d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6616757bf3a192b414623d7d31da70cb2ed480ae4178be6f092791c958b9135d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6616757bf3a192b414623d7d31da70cb2ed480ae4178be6f092791c958b9135d"
    sha256 cellar: :any_skip_relocation, sonoma:        "89bcc993f2d9b0009dee275c81ff9ea15c68b7cef8e81ab51d18132092c3ab6b"
    sha256 cellar: :any_skip_relocation, ventura:       "89bcc993f2d9b0009dee275c81ff9ea15c68b7cef8e81ab51d18132092c3ab6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ad22a96faccb36f353d78f58943f827236930048d868f4e9fba2fc4b2b53b84"
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