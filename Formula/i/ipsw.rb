class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.693.tar.gz"
  sha256 "d9e5d60e7f11f22b0b70d6008015f253b6ae9d7f9695cc7e904e0014d686f8fe"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38d030e171d7df936d37042304e2f9661c7a52631171823db5f008d157edc4ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72fff246fe21ae39c0574b18f0a8e9c7cf6a44a7ee10851de394ae514ab661e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0cc255229a70decf9bfbdd03df9b8ac660074d299d6028c500415737b457502"
    sha256 cellar: :any_skip_relocation, sonoma:        "2412accad4ceb8ef851d8cfe1ac96e077b6a65a072eaf6a783c442a79b725813"
    sha256 cellar: :any,                 arm64_linux:   "f9337ce896182f5977e6ac10268be7b512adda8784b0811681d7746ae7bad58c"
    sha256 cellar: :any,                 x86_64_linux:  "8e4a62439ec89a698f952afbdfbd143da6c1ea85f33d0dfcab901da264b7352e"
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
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end