class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https:github.comleg100pug"
  url "https:github.comleg100pugarchiverefstagsv0.6.1.tar.gz"
  sha256 "9e6af6d6922c0a3d14171949f5a659d0f8ac71a882bb880793df3737015ecaae"
  license "MPL-2.0"
  head "https:github.comleg100pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25c7db8bb13fabc5e5588c1c8ff458a3bd74646b894cc898956d055839e2be4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25c7db8bb13fabc5e5588c1c8ff458a3bd74646b894cc898956d055839e2be4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25c7db8bb13fabc5e5588c1c8ff458a3bd74646b894cc898956d055839e2be4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bee6cffa57d3a40bfb4432f636698c5786ce86e5b5a235124d0344e08e11db37"
    sha256 cellar: :any_skip_relocation, ventura:       "bee6cffa57d3a40bfb4432f636698c5786ce86e5b5a235124d0344e08e11db37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e61c48f739429a0177e942409bfa6adca3436aa5b3a9644820b52c36c0772a16"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comleg100puginternalversion.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pug --version")

    # Fails in Linux CI with `open devtty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath"output.log"
      pid = spawn bin"pug", "--debug", [:out, :err] => output_log.to_s

      sleep 1

      assert_match "loaded 0 modules", output_log.read
      assert_path_exists testpath"messages.log"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end