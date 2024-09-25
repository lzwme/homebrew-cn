class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekit-cliarchiverefstagsv2.1.5.tar.gz"
  sha256 "a9e486833e17ecb6088909e999dfebf3e91490df7e6029fb0309fbebae6d858b"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce3b826e8b6416692bdb05890c60d37c88914e2b6dabb21cc7312c44aea84351"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce3b826e8b6416692bdb05890c60d37c88914e2b6dabb21cc7312c44aea84351"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce3b826e8b6416692bdb05890c60d37c88914e2b6dabb21cc7312c44aea84351"
    sha256 cellar: :any_skip_relocation, sonoma:        "80823fac717359af4d98380db203fa6ac0fa4320b46557fc4480cb4270214bcd"
    sha256 cellar: :any_skip_relocation, ventura:       "80823fac717359af4d98380db203fa6ac0fa4320b46557fc4480cb4270214bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5afda66cd85e028ca09823bff65d4c0cbc59a97db2b553a80fe377e33ebd6b88"
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