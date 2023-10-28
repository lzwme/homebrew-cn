class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://ghproxy.com/https://github.com/Nukesor/pueue/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "92a6cd4aa11966cb1eedb4678e8269a184cbd04fb07216013c73cbb6a0b45e08"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "484936a208b03f81e344652dbee63f0ea4cd89ce59e5901edf7d4576a7290956"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17e9873baf4de6477652d4a4e38749e1d9745ea62ec6877c363e541ad835df5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9a8ddc64e644778cc9004fe5591616aa52d1830ee5f60fd177de77edec5045b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a08585e21e0c1dac54159c2af683bbe1121f89775de3187df1e088f41560a734"
    sha256 cellar: :any_skip_relocation, ventura:        "213fde90c0054a75c04d97c5ae22c8dbf4ae5e9a2a11d5065767fb75757f39ea"
    sha256 cellar: :any_skip_relocation, monterey:       "3c71468f0678bf0390dd81add2820c50cf3dfb5a6e9f72b7f2a65c209f4ba7aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a802677e56bbec97b8df99ca0a08c2753201714b155acfdf4890e0d5490eb07"
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