class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v10.2.7.tar.gz"
  sha256 "eea957c840041e11cc214b5f9c31801b0f8b51621d6629b89ba5743788d8e7c6"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8fa0ad31ca554185a8fdf72401aeb5784d6d5bc20a6f8cd93d723829c02aed4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8fa0ad31ca554185a8fdf72401aeb5784d6d5bc20a6f8cd93d723829c02aed4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8fa0ad31ca554185a8fdf72401aeb5784d6d5bc20a6f8cd93d723829c02aed4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c95cc1b65e3f08afb81fb9b241465daeec7bdf5b044b06f803545c9165d073a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35bccd61ddaf84eaaf08877a5328a8dbbd2e8a97a9d972a2749573fe7f983c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91bb81e86e2399372843b839b37149a8d0cae04e6e88321e83903c4286954dfa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https://github.com/schollz/croc/pull/701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

    port=free_port

    fork do
      exec bin/"croc", "relay", "--ports=#{port}"
    end
    sleep 3

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 3

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end