class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "483f442d7f85639fde917b3ad6d64a01394c9710269ce4a374b08411a41d23f9"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02d98b136db4ceff3184071817bc2dd4bbc3b49e3f3b3ae6cf268367053820a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ebb2607620dad5244470cd89a9f36c29c6b8f6109b5ae1f0eca8a7e3f76f1f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c99e0159548f4488bf9e7ab762a181ae71a75d7f0a3258190855f14f40fa736"
    sha256 cellar: :any_skip_relocation, sonoma:        "53f7b6df1237820732f62568f497d54e990a18bd36db4b69de87f4c44393aa98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7304c617fc1cb95898d470d9bf3938e2d9f6d1ca0e0b74851e38941dee2e56f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbb1066c9873d463dbdb16c32488a3c7bf44ad5cffd7fc298d79d834cc27da2b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert_match "valid for (mins):  5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end