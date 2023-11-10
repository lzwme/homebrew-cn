class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghproxy.com/https://github.com/schollz/croc/archive/refs/tags/v9.6.6.tar.gz"
  sha256 "9dd954e0068df2be416c71161665bfc283f150d30ba0bf96cee723701e93616f"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21b6f7c98dd5036ee4849444cabce50531eccb48a587b46d8e160093656c8a9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00ad494b6dd19f28a19662209ac812ec6c0adf9fb0f91c94e6073639b5842135"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd9cb1d51fa88744e8669966e3100964a10a02a769650a4a54761a7be36b38f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "25f7320e27aac35f89d57c581ae47c7e9f701e5d4924ccc0326ca67c6259ffce"
    sha256 cellar: :any_skip_relocation, ventura:        "af789dbd6730f4bef6b583ddfb9408566933b514624deac041315ce2d436e872"
    sha256 cellar: :any_skip_relocation, monterey:       "66894d0391934c4a564c8d6588096ab0ff2812abaef6c8521bfb8fb0acd796f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0be2d1a21436a9914e90487389d2c28355d1fe12d235bf0d4057904654fb1155"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port=free_port

    fork do
      exec bin/"croc", "relay", "--ports=#{port}"
    end
    sleep 1

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end