class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://ghproxy.com/https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.15.9.tar.gz"
  sha256 "a908cedbab59c48a30a94518c92d2a20b34f373c7e1654f1d398aa9cd8f3fc0b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ce6fdaa550fb8eefcb2c758719ac104ccc04767c9903f6f9aaffe856bda8753"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20f08fb617bb4ee5c4a19492a2bcb71084839a43be9e5e671c3abf67503549a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a1f2fb372314a486307a8af1efb77866169c9f9323901fbff9949be153117bf"
    sha256 cellar: :any_skip_relocation, ventura:        "5567d10914f2494f56cf9fdfd60120143c87c47ba9409b81d88ce729d4db9de0"
    sha256 cellar: :any_skip_relocation, monterey:       "46498a903804e625c8a5ca7c71e55ed999320d9884412da86f683d2fede428bf"
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