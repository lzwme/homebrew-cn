class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.25.12.tar.gz"
  sha256 "8ab3eaebaabe13ad04adff9d02023718502e5d3057641efed1602460c83fcfd9"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7fe3d8ff8bcb6a7ac10d03975363cc041ab60a9a4ff72090e8b1d7c44af7887"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4f77d6080cb525a276f29b67c7209de516d1d4bfda5b1eee8ca78d9f5c3ec8b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9843b61931a2b7d15f330e2bb9260e6fe066f999e3533ac44fd373b9fe2dd9d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a5991c0c8cc41e777f4e644bf5f3539b11c4ba7bf376e470e5a7a1c68a26732e"
    sha256 cellar: :any,                 x86_64_linux:      "cbcc3e89f7f374e9b637e46e4723469faa66d19fcf67b862c5ef971b22f63ff1"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end