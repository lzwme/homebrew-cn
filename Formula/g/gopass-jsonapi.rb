class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://ghfast.top/https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "eb8f48f23219ef4cbc16944976a42bdcd5f1e74cb892cde3bd8a5aacf451f094"
  license "MIT"
  head "https://github.com/gopasspw/gopass-jsonapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87226462e9fb1b55b1933423bf32a34599c5d4c1e768677b2b1be72de186ea0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f0b6dfb8fbe9a793261df9f44be808fcfad0c82a3c42f4241917d41dd1ee54a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "856747d0543db4f65737dc79af71b3e8746b5fdb8a6a316d0a504375f7b7701d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66ae313217652eacc854ad546ee0b1519871beb9f99aef7b4d68568314bf4286"
    sha256 cellar: :any,                 x86_64_linux:  "d78b98827aed36ee8fb4cb667dfeab265c856e8a4f165fa62c6e25beea18c81c"
  end

  depends_on "go" => :build
  depends_on "gopass"

  on_macos do
    depends_on macos: :sonoma # for SCScreenshotManager
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    (testpath/"batch.gpg").write <<~GPG
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    GPG

    begin
      system formula_opt_bin("gnupg")/"gpg", "--batch", "--gen-key", "batch.gpg"

      system formula_opt_bin("gopass")/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system formula_opt_bin("gopass")/"gopass", "generate", "Email/other@foo.bar", "15"
    ensure
      system formula_opt_bin("gnupg")/"gpgconf", "--kill", "gpg-agent"
      system formula_opt_bin("gnupg")/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end

    assert_match(/^gopass-jsonapi version #{version}$/, shell_output("#{bin}/gopass-jsonapi --version"))

    msg = '{"type": "query", "query": "foo.bar"}'
    assert_match "Email/other@foo.bar",
      pipe_output("#{bin}/gopass-jsonapi listen", "#{[msg.length].pack("L<")}#{msg}")
  end
end