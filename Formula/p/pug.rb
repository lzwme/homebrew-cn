class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https:github.comleg100pug"
  url "https:github.comleg100pugarchiverefstagsv0.6.0.tar.gz"
  sha256 "ddafc44e9a844036dd802edd3bc8b229aee0002a4a0b83768a37f04243c3044a"
  license "MPL-2.0"
  head "https:github.comleg100pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35c14c575b0546e893a43b89e5b2b0a3fe700b8341b0cb1725514fbb2868bc4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35c14c575b0546e893a43b89e5b2b0a3fe700b8341b0cb1725514fbb2868bc4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35c14c575b0546e893a43b89e5b2b0a3fe700b8341b0cb1725514fbb2868bc4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "957a1abaf2d15ad8d2c688a42b0458b554d4e48870baeb4bc5c9d7425a3e99dc"
    sha256 cellar: :any_skip_relocation, ventura:       "957a1abaf2d15ad8d2c688a42b0458b554d4e48870baeb4bc5c9d7425a3e99dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7be671c9920414fc1a35724a00355561e558d32130ac463aded4d5b9095138ee"
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