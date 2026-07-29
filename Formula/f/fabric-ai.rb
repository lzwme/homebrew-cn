class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.463.tar.gz"
  sha256 "d81ef83ba82d187faa16a353b4847580dfe67f1c14de1221dc8481a581eb2bf6"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43db37aeba5f7f67918f344d5d994ee7bdb89bb649a41d00859bb87b932bd2e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43db37aeba5f7f67918f344d5d994ee7bdb89bb649a41d00859bb87b932bd2e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43db37aeba5f7f67918f344d5d994ee7bdb89bb649a41d00859bb87b932bd2e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "99893cfd4256a0dac035abb1d8e00abaf43f5266ff1449c241573f844d2a42a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6031358ffe5267f173bd811aaf1b53f45c6ae4a18ad4639902c3525ecf55b65"
    sha256 cellar: :any,                 x86_64_linux:  "c5046fadcbded3540e736007f6f740f7f631f85980852e4be13182757843f70e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end