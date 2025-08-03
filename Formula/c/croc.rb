class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v10.2.3.tar.gz"
  sha256 "96c17b9fa6c55c0a1e02937c5f2d34bd2ce5b7ef6f844f16eac8d155c1b8a119"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ab574333a07b83fb71dda8ea4de38d232d00e609466196db3252de8cf4017de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ab574333a07b83fb71dda8ea4de38d232d00e609466196db3252de8cf4017de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ab574333a07b83fb71dda8ea4de38d232d00e609466196db3252de8cf4017de"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fcf4d41a53b35ab919d5d617ad2424762a1435759eb071365abc6a36d64d99f"
    sha256 cellar: :any_skip_relocation, ventura:       "5fcf4d41a53b35ab919d5d617ad2424762a1435759eb071365abc6a36d64d99f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fac738d4b394464806a0f3a8e1a2bbc92f8bcd2edef0fb7865f4c1bdb6527977"
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