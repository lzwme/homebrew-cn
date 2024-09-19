class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekit-cliarchiverefstagsv2.1.4.tar.gz"
  sha256 "c180b712e5f610f3ced0bca44bef2bd54f428b760991adca7dc9a25895a5cb50"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93cff3b8858f5e6acbe85c3257cc7254d9db0aca8c737bbcec90d9a1e04dc5fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93cff3b8858f5e6acbe85c3257cc7254d9db0aca8c737bbcec90d9a1e04dc5fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93cff3b8858f5e6acbe85c3257cc7254d9db0aca8c737bbcec90d9a1e04dc5fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "e23bb9a0a03f54456aeb16a193e6009b6bc1a353cc07351db3860dd513c1cc85"
    sha256 cellar: :any_skip_relocation, ventura:       "e23bb9a0a03f54456aeb16a193e6009b6bc1a353cc07351db3860dd513c1cc85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ac02ac1bcb59f6371a50c9f4cf5af1238283f2e67e3d17f9e1f9a1e57b2b0a0"
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