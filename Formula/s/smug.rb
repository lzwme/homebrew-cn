class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https:github.comivaaaansmug"
  url "https:github.comivaaaansmugarchiverefstagsv0.3.5.tar.gz"
  sha256 "56a49f3eff84be8f7cc1c202f5223f6ceebbe5236095dcb669473d5659eba45f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b1f04f414bf5f3b0b60c5c5c50466eecdb17cddf423eb8c74babb4a81e4a7cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b1f04f414bf5f3b0b60c5c5c50466eecdb17cddf423eb8c74babb4a81e4a7cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b1f04f414bf5f3b0b60c5c5c50466eecdb17cddf423eb8c74babb4a81e4a7cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "72d64663ac113f30e808efb528756171cb25882c8c5610dd922228e0e0a3f3ab"
    sha256 cellar: :any_skip_relocation, ventura:       "72d64663ac113f30e808efb528756171cb25882c8c5610dd922228e0e0a3f3ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dca1132c8cbb2da4aa2416a4a1552bb47f202ed1ea51d637cc5919b4f2e39fb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    (testpath".configsmugtest.yml").write <<~YAML
      session: homebrew-test-session
      root: .
      windows:
        - name: test
    YAML

    assert_equal(version, shell_output(bin"smug").lines.first.split("Version").last.chomp)

    begin
      output_log = testpath"output.log"
      pid = spawn bin"smug", "start", "--file", testpath".configsmugtest.yml", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "Starting a new session", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end