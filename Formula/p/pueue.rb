class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://ghproxy.com/https://github.com/Nukesor/pueue/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "5d880731b7911dcc01c84ad547d703d4d438a95a64396d3610829d0c05bb1e37"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "599fe78521efc7d20d90d97ccb7b1b7ac914f531af9af5f580fd3fadcf428de9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ce5506bc5dd780da0d0f86092b2525cff4751d097d88f9772f871712fab6222"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "488520cc99bb81710fe69fe327fba8bed865d37d24866c7e96b69f1606e6671d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1bd23f74022c1cdf6d7e827c8a25fa781cd2ecc2fe5e014841bd45c9cd475ab"
    sha256 cellar: :any_skip_relocation, ventura:        "af0606428aec3837da6a58adccbc747f6f9819d4e767cc23802591a532664b27"
    sha256 cellar: :any_skip_relocation, monterey:       "4023a05da6866735b9f098738943a3d6bead04b8292d1f335c2874752eec3fb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "440eea8d399fb5f92273dee0a729282f3eebc5feb1946e94474e966f0000ee05"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "pueue")

    mkdir "utils/completions" do
      system "#{bin}/pueue", "completions", "bash", "."
      bash_completion.install "pueue.bash" => "pueue"
      system "#{bin}/pueue", "completions", "fish", "."
      fish_completion.install "pueue.fish" => "pueue.fish"
      system "#{bin}/pueue", "completions", "zsh", "."
      zsh_completion.install "_pueue" => "_pueue"
    end

    prefix.install_metafiles
  end

  service do
    run [opt_bin/"pueued", "--verbose"]
    keep_alive false
    working_dir var
    log_path var/"log/pueued.log"
    error_log_path var/"log/pueued.log"
  end

  test do
    pid = fork do
      exec bin/"pueued"
    end
    sleep 2

    begin
      mkdir testpath/"Library/Preferences" # For macOS
      mkdir testpath/".config" # For Linux

      output = shell_output("#{bin}/pueue status")
      assert_match "Task list is empty. Add tasks with `pueue add -- [cmd]`", output

      output = shell_output("#{bin}/pueue add x")
      assert_match "New task added (id 0).", output

      output = shell_output("#{bin}/pueue status")
      assert_match "(1 parallel): running", output
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "pueued #{version}", shell_output("#{bin}/pueued --version")
    assert_match "pueue #{version}", shell_output("#{bin}/pueue --version")
  end
end