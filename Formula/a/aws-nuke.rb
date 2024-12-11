class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.35.2.tar.gz"
  sha256 "f6dcdc0fbbef5911d0446510c34659a342da2b35df8ba23cfcfade922fdd91c9"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab3cec84b73e15957d72600767d661a671f8ef19ba8d9eb58d0136ce69a7413a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab3cec84b73e15957d72600767d661a671f8ef19ba8d9eb58d0136ce69a7413a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab3cec84b73e15957d72600767d661a671f8ef19ba8d9eb58d0136ce69a7413a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2fd69d47e3b04e401a2115490a6db95d4163d1f3bf4d3aab00b15e195045c8f"
    sha256 cellar: :any_skip_relocation, ventura:       "b2fd69d47e3b04e401a2115490a6db95d4163d1f3bf4d3aab00b15e195045c8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42a4db18224a53075150083842a6e412921a23a75cbf960876b60a4df97e773f"
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