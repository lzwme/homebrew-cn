class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.638.tar.gz"
  sha256 "9a0e12b9fe44ba64fad1e3a96b329712ec158aadfaca4b1ec3068cb2cbee3df7"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97abb30ae0856f22f2409ceae196a0b366ed6297037cb628c16b18279bc45b11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79c19f8b4ad6a26ae299bff7a64fac0ca0a540c29e3d9f37b670ed902a5552aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c80bfed007d70b2cc8eb47de21533538ed90d61a57980dd18a926acbbc48248"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b15892a9771556cff25663681490e4dc36e6dc34150ae74409b6af0ce173bc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ad72097ca7ca83e8234f377dc6ae3c8308ded5ed76651a6463c4913ca6f9938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "220257ff0f5670274d93d5360836031ed7e5fba1306fa884bcb04b97e6519e8f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end