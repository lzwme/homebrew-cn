class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.698.tar.gz"
  sha256 "e9ca0df134a995d8fece61d8f42fa4eeccf1857c7f913abf05dee12550e99c6e"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "037b1bbc5f79ebc91830ac958feb697f92be8d6b799cb2f3041d4d170e6278bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c65231257eec29e3cab412ff061eb61f28b763d5fa531a4398edd7df174d2e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b96df5eae535fca030068c3008ad639c834bc0f28629da1f0b244361c39bd98"
    sha256 cellar: :any_skip_relocation, sonoma:        "57c20debbc664663db21808b959b1f73e2110d5543984efb70814e3fa3253e66"
    sha256 cellar: :any,                 arm64_linux:   "a316dee4d4e9b5a681a3844abf3fc9bdba4264b99119b99ef5b412c7b1d29170"
    sha256 cellar: :any,                 x86_64_linux:  "ade7f126758b8b4e5caffe8c32bac5dd6b8d2c238150732b616f17ef886bc03b"
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