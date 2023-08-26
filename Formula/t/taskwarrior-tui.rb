class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://ghproxy.com/https://github.com/kdheepak/taskwarrior-tui/archive/v0.25.2.tar.gz"
  sha256 "d594c63ad2191dbebd0842790f64c73b28de00074f7b20c10e8326d78db039c1"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19de8cddfa9ea7da09df4e1cffd209b59c49a29b65d8a091f9eea92d423717bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "506e6cd55eba0f7f661704b829cea2687bfbde2558b4d82d07fc58b4a99c4f17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbd7d3bbdb51871db1a40e3511586baf681b7380fa62bb056dfb3f5954e63b06"
    sha256 cellar: :any_skip_relocation, ventura:        "0ae1944e6541ff4d769165881781a2214e127f9a77aaa16decf623678c59c6d6"
    sha256 cellar: :any_skip_relocation, monterey:       "a28119875b522ca1019e72542480578047fcdb47d3e4462fee5d01c78fe28ed6"
    sha256 cellar: :any_skip_relocation, big_sur:        "42be6d405f3f657b2597c2029ee2398b5c99a4d92dd967b19d9f3f8cff5add70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2a3b137c54cf2d9882a0d9ad0b154dbdc07a6fbc8d9addb6dceb11f4e0dc9d0"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "a value is required for '--report <STRING>' but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end