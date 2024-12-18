class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https:iroh.computersendme"
  url "https:github.comn0-computersendmearchiverefstagsv0.21.0.tar.gz"
  sha256 "52cd84b40df4c7af87cbe82de5bec22d536cd63e98cbb457a811495d38366905"
  license "MIT"
  head "https:github.comn0-computersendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4679a0475979780347d178544fde7bdef2aa5e490875de18a0c5fe121409c7db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2719a62028c580da671dd3c34ac3330372322e08e7b4b57ca7761bb6978c010b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f49c00a5686ea5e85396208be853f9968e7ec93b114e3146a7bab34c6266eec"
    sha256 cellar: :any_skip_relocation, sonoma:        "feb8fb14f4b3459deecffba1cdadd37952f92277f1ee837d022966f2b8d389ac"
    sha256 cellar: :any_skip_relocation, ventura:       "945027cb242cdc3146c47b821aa835b6b38b1f4db605a05016cb6af810f8e0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a322697c43d2eea6e76604b8da6f0481b4dec3f86f268edcd6b4053f0dbffce8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sendme --version")

    begin
      output_log = testpath"output.log"
      pid = spawn bin"sendme", "send", bin"sendme", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "imported file #{bin}sendme", output_log.read
      assert_match "to get this data, use\nsendme receive", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end