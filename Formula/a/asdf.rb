class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https:asdf-vm.com"
  url "https:github.comasdf-vmasdfarchiverefstagsv0.16.2.tar.gz"
  sha256 "fb712d19f2c0bad65b0cc5c7c1cf8a477b5fa05d6836feee63068d1c2dbdb30b"
  license "MIT"
  head "https:github.comasdf-vmasdf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a16f2e4575075b2ba97b6c4927f6a5aa7e06ecf85b15941b8da21ad9f760cfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a16f2e4575075b2ba97b6c4927f6a5aa7e06ecf85b15941b8da21ad9f760cfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a16f2e4575075b2ba97b6c4927f6a5aa7e06ecf85b15941b8da21ad9f760cfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "260b76ebe235bc467df21e3d030786adbd43654e15c4e8e4c5fb7a200bfb1cb7"
    sha256 cellar: :any_skip_relocation, ventura:       "260b76ebe235bc467df21e3d030786adbd43654e15c4e8e4c5fb7a200bfb1cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c58e5c89e4c25d1faedf93974b786c9fe4e871a55961aa3e9c20dca90a84fa5f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), ".cmdasdf"
    generate_completions_from_executable(bin"asdf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}asdf version")
    assert_match "No plugins installed", shell_output("#{bin}asdf plugin list 2>&1")
  end
end