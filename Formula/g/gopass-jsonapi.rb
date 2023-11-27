class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://ghproxy.com/https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.15.10.tar.gz"
  sha256 "535af8ffd0d939e545209c3c27ce43a16ca5d6523c3c476eeea861cd7272d093"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d010b7089cb85d4fad54a0d385edf56584fb5047fe63a5a257174185e8dbefd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4a4d8676ba270a820f3376908b200fa1ffb0e3d27494c83d11b340fad09c9ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76cbcf26f45cc478abba321c48c145bb76e21b3b0a671a5f442933156cf393ff"
    sha256 cellar: :any_skip_relocation, ventura:        "b0135ca19218680cf87b48b3330a54cf02fbe1b8d184787bde993a8ecd858d33"
    sha256 cellar: :any_skip_relocation, monterey:       "32e7ebf94bb3c2a89e3d6ce5bc4d105feed3352044595bd47276b80f506df941"
  end

  depends_on "go" => :build
  depends_on "gopass"

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS

    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"

      system Formula["gopass"].opt_bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system Formula["gopass"].opt_bin/"gopass", "generate", "Email/other@foo.bar", "15"
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end

    assert_match(/^gopass-jsonapi version #{version}$/, shell_output("#{bin}/gopass-jsonapi --version"))

    msg = '{"type": "query", "query": "foo.bar"}'
    assert_match "Email/other@foo.bar",
      pipe_output("#{bin}/gopass-jsonapi listen", "#{[msg.length].pack("L<")}#{msg}")
  end
end