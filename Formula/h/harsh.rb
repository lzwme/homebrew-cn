class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://ghfast.top/https://github.com/wakatara/harsh/archive/refs/tags/0.11.6.tar.gz"
  sha256 "f978708b70f0189b662f470ef3e2e932cfec3f3fcf63f7cc0cb41799b4cac3db"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79fb81a08b4a5d14b83ef1ec630115ca035f6d5a65f664b3fb66757a31c4a4a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79fb81a08b4a5d14b83ef1ec630115ca035f6d5a65f664b3fb66757a31c4a4a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79fb81a08b4a5d14b83ef1ec630115ca035f6d5a65f664b3fb66757a31c4a4a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dd64a6fa087e769ccc6606ac272181d22d04fb8532d0f50398e3112f89b2d85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "546186ce63ad02082e9edaaa63d55e021ac982635571f9cb2a5e9b6a4f9e667b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716e36cf0ee965fb087af0a93481ff8a4cc4cfcf8df3fb8397ac383b8b551352"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end