class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.686.tar.gz"
  sha256 "3ad073626676c08bb6d8643adbdde01239a4ddb76676194828192b8982de1e5c"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b348db660ee8f174d05d2d13f6077196286f2c1347c43c801eb0aa175d6c6562"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35144c4b235ec9a4adedc5a9e444bd0ab38f12fc69d3cda97dfd79cea3b986de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d659d51a694c901b00c001e7eb090b6e3899de9fe6dc3fef825b5cdac46e04a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dca23167d770992d74f964c15bc8d7ce281e9035dc11add408a75654adaadc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6980c95c31b92e25a84af3b8af6f9dda072ff30ed4cb6b470ab2a078233e23cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b934fad9408b5bef65a619060be2d2dc23d71256f57a0283224d7fec210b369"
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