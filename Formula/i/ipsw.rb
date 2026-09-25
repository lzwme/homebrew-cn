class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.724.tar.gz"
  sha256 "55e1a9f6f5c0106c588d66a0977a65d4b983b730b675d50bdaa669dfaeb02225"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f76c829f43bef8e6e5e6df7d6a946a05cf7fb0354f5656c650232410c2b4b88b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21cfcd8903a54a1c1186198994cf68d15a072d58075f5e4e1836017e06695f94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "99919189e9c4174129680708366f14eb4c6de801cd17adcf67eb19ba89c64702"
    sha256 cellar: :any,                 arm64_linux:       "ddb104b5b4db43f3a4f33f0e15dd6298a29c1392e628569dd822d9dd11a46141"
    sha256 cellar: :any,                 x86_64_linux:      "25768626a687688b159dc89369e4628ce69d933885d676706af1fd20bc2c7bd0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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