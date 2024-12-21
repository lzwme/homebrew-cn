class MagicWormholeRs < Formula
  desc "Rust implementation of Magic Wormhole, with new features and enhancements"
  homepage "https:github.commagic-wormholemagic-wormhole.rs"
  url "https:github.commagic-wormholemagic-wormhole.rsarchiverefstags0.7.4.tar.gz"
  sha256 "3ddc40c82faa381e96ffdc54757625a4707c1bd111d67ab2ec733a5bb666a43c"
  license "EUPL-1.2"
  head "https:github.commagic-wormholemagic-wormhole.rs.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f46eb70c04e3a06978a0bb63cc5aafd2727467931d6ba11a106aae14270a3a1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65521995b87468603204f09ea6dea02dd3c60a9c1d906c21caa8e70d41706c20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f9823d71411bfd399a6af92c08afcd52dbb164d27cf8a1feaa43fdc3f654359"
    sha256 cellar: :any_skip_relocation, sonoma:        "983692bbf7dd98cfcc733ee25928504c79a8f2e66d3dd723f9cd4ec5f19927cf"
    sha256 cellar: :any_skip_relocation, ventura:       "219c8c34004646ae1d079ab541afb7904a7776644e8ebc014bdf28ac94159fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f273cd3da5ff6f41cd0178d4a926624b2f397402c807869bd112edfeee0a963e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin"wormhole-rs", "completion", base_name: "wormhole-rs")
  end

  test do
    n = rand(1e6)
    pid = fork do
      exec bin"wormhole-rs", "send", "--code=#{n}-homebrew-test", test_fixtures("test.svg")
    end
    sleep 1
    begin
      received = "received.svg"
      exec bin"wormhole-rs", "receive", "--noconfirm", "#{n}-homebrew-test"
      assert_predicate testpathreceived, :exist?
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end