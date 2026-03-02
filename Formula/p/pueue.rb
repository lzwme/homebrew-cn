class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://ghfast.top/https://github.com/Nukesor/pueue/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "4c1acbdbd5260b0b7f76aae7ad142665de664745a7ed63425190e06c0c7478b1"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e1dcb7ea68b64e8831cadd514d6e520b25eaab9b011ded7f4850f564bc60031"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7159ab05aafcf80f708cd75cea82cb04c0b3957dd9e9437e59f1923f4e31d6b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75c57f43ef0ac53793fc370d87ed6360d35f7c4b996f5cffef4a522a32f5314a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfe81c17d789b872302f351fcdd1b5dcd384de3e6d2485f459aad21fa5d95f0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0034a5aa5720bb557ac2e6f30bc9ae9f42c4dec8236fc2ab72940687fcbfd6bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77ef12625be1fcba0b4307a6b18b4c79919b634ecb914731c507efd230818a19"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "pueue")

    generate_completions_from_executable(bin/"pueue", "completions")
  end

  service do
    run [opt_bin/"pueued", "--verbose"]
    keep_alive false
    working_dir var
    log_path var/"log/pueued.log"
    error_log_path var/"log/pueued.log"
  end

  test do
    pid = spawn bin/"pueued"
    begin
      sleep 2
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
      Process.wait(pid)
    end

    assert_match "pueued #{version}", shell_output("#{bin}/pueued --version")
    assert_match "pueue #{version}", shell_output("#{bin}/pueue --version")
  end
end