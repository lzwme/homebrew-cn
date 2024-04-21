class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.13.tar.gz"
  sha256 "9140b22add3805d7d68da1b8d817645e2ff65d3d5ebc502811d8eb2b0ad2b38d"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adb086ff935178cd5622c84a54aee9edbce3c0edcd470f2d46a138a60cb6f82d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e64962e50c0eab98a2f73279f96f505f9ea036368e2080d83b9b7ddc8df05197"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11ea700aee9fbcea9b10b7e3255a91c059e387590be47509309b147e1623543e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb4a58080598db366c738d15004e6737f077c8d9e82b55ce1cae03e9a0d5f3d6"
    sha256 cellar: :any_skip_relocation, ventura:        "dd6a033b9d2b75d590cc9805dcc90b2df4f83317371e8bdacef45ba21f2237cf"
    sha256 cellar: :any_skip_relocation, monterey:       "79e68377b2587a2c14999e864d9aab9c7fd1710bb7e21b6ead78e01b30392704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4a126bd4fc0b6c526b8c4a2b37c58da7aee79db8aa174cdf0a7de455dbb5c3d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), ".cmdneosync"
    end

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end