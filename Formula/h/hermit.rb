class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghfast.top/https://github.com/cashapp/hermit/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "1df9ad745443e02769978e2ef44b0664e026b0bdce8f36c017280fa44caeac9a"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "15ed8d7eee994bfecd64ea2de804401992cadf60278dbf757b05761ffe648ebc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5547ccdb10151e164249af46995cf84548bc456e12bb6cfe80bf88ac796b4c5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "23d95c0a39e728489eea93ad6cc5d93db8feb4a9acdd4ae0830ddc1064393c99"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5008a109b56d2c96c2ae04aa8692facc998770692bcaaf4b2ae7121c5901c952"
    sha256 cellar: :any,                 x86_64_linux:      "2264860ee97613590afa68fccfc12eb6b185c613517d896effb47e7af8fe9c6a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hermit version")
    system bin/"hermit", "init", "."
    assert_path_exists testpath/"bin/hermit.hcl"
  end
end