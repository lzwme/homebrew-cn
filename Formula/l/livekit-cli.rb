class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekit-cliarchiverefstagsv2.1.0.tar.gz"
  sha256 "b49a395169381140f39a9da8308ac100626e7697862fbee1e6c49fa9d1bce657"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9d91067d5c7cbc881226ab29dc2ed600224581f22d39b6a5e4820709fc85c564"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8644570224ebe08fd208ba778f755584ecd6b19880ea5fbf2ec6a152398adac9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8644570224ebe08fd208ba778f755584ecd6b19880ea5fbf2ec6a152398adac9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8644570224ebe08fd208ba778f755584ecd6b19880ea5fbf2ec6a152398adac9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8600c4439b4a701ab80d9f34e6d6a8d0b337dd147defe8c999c783d72db5f4b"
    sha256 cellar: :any_skip_relocation, ventura:        "a8600c4439b4a701ab80d9f34e6d6a8d0b337dd147defe8c999c783d72db5f4b"
    sha256 cellar: :any_skip_relocation, monterey:       "a8600c4439b4a701ab80d9f34e6d6a8d0b337dd147defe8c999c783d72db5f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4909db963f9723900726e5120fbb3fd3fb02a163a9c056d11f26c16523fa7ea"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin"lk"), ".cmdlk"

    bin.install_symlink "lk" => "livekit-cli"
  end

  test do
    output = shell_output("#{bin}lk token create --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "lk version #{version}", shell_output("#{bin}lk --version")
  end
end