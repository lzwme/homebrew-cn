class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.52.0.tar.gz"
  sha256 "69173f6e687fd0bc797012eb4258ffcfffd30e38f7264583cb16a84356eb1efe"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42e9cc09f74b54a5d8458b4290d0c86c5f95808f2f9279b0cf08c3154dee8c1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42e9cc09f74b54a5d8458b4290d0c86c5f95808f2f9279b0cf08c3154dee8c1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42e9cc09f74b54a5d8458b4290d0c86c5f95808f2f9279b0cf08c3154dee8c1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "edf4fa06fc64836859466c90b21005bb6a00f4361e2200eabaf190fab8e3bd25"
    sha256 cellar: :any_skip_relocation, ventura:       "edf4fa06fc64836859466c90b21005bb6a00f4361e2200eabaf190fab8e3bd25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ff3520c94e313e1df99f92aefea6e13896dee342c41c4366708bcb9b73e27f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5670a4275be1f7fc140819070c0612dcedb890c80d338282f6b9706365ff0bcb"
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