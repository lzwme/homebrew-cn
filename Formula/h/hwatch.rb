class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://ghfast.top/https://github.com/blacknon/hwatch/archive/refs/tags/0.3.20.tar.gz"
  sha256 "df5edf3e8cd8ec3ce0cf59ee48590d2f0ccad1ed6fb68ce16caf31a21983160a"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbfcf242956b948038552b56ea6400100265e235ab5961d5d06abc96d9b109a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1e91241cbb57069402224ab0a37f6934e5db3a8c3d38f80bbbb248a7c8603bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d294454071d036940437420c8aa779013a423c18062862cbb113627444aad60"
    sha256 cellar: :any_skip_relocation, sonoma:        "01bfdd869c1c23ee9b67aa411a275840583985a4395c66f59d2067ffe68bb752"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3384a30c4c0ec39aa79d0586d26146886412848ab1c72d8bba4ae8b07f454f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3ff129434a9834347f980009224a9217af9bcc01500d7805472b95aad1be011"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/hwatch.1"
    bash_completion.install "completion/bash/hwatch-completion.bash" => "hwatch"
    zsh_completion.install "completion/zsh/_hwatch"
    fish_completion.install "completion/fish/hwatch.fish"
  end

  test do
    begin
      pid = fork do
        system bin/"hwatch", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "hwatch #{version}", shell_output("#{bin}/hwatch --version")
  end
end