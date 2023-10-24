class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://ghproxy.com/https://github.com/Nukesor/pueue/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "95f9c2744c6b9c43cf9e78864fcc05478aad65527786cb9ab5c58c2b998547de"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a44df75fa284b5b70af79d80ba08700136eaf5c50e16c94f705e655d3e64cace"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f1c491a489c175e3456521ce977ae0e06a47b4b0229562489c72d5f5a648451"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c3d98e63da65030b03824ee863edfb37c991505d993c432df897fbb73fb3845"
    sha256 cellar: :any_skip_relocation, sonoma:         "09cbfd7646b43df5805e566e3966c2d997860cd3aa1fbfe7b0982beb63009daf"
    sha256 cellar: :any_skip_relocation, ventura:        "32691a005625dbdca22f57dcb1073cbaa683087b9611b3f30fe479f8a47900e9"
    sha256 cellar: :any_skip_relocation, monterey:       "9231adf484f79efa03fabd450fe7400292dc5eaa624417bcb9755d68faabcf49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f10330bed9a4dec2393318e331f84ac11425a54de0e18ea41160df32763a520e"
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