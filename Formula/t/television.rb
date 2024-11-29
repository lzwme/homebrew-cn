class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.5.3.tar.gz"
  sha256 "2010564e2afcf6874f410faab6c235fe99943c35a944acbfe7fb9d9a3680d406"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1ad2bc6f2683f9e9b23f392ca662db2a78eb970736615de18dd984096beba76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0cb553564fc701584986460011f3652642ba6a66566ffa4555bfb7f42194d41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3996fc393dd33005407d8548732ca4f1d13548e1e68917a32f840dd34cf85831"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8f34f7635c566b8096ca8b4cc14fccddd3ec59fb77db2cdd3a46573a60a5bcf"
    sha256 cellar: :any_skip_relocation, ventura:       "a59a0837fd1ce2714b8e5161d71ebf7e94e452b5cfc67d071da7d41d9d092c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7239aaa77835ca43a1a523cd96b3c2acd449bdc76367b07b55b2e1dd0abc792c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tv -V")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath"output.log"
      pid = spawn bin"tv", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "Channel", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end