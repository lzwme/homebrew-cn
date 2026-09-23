class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://ghfast.top/https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.17.3.tar.gz"
  sha256 "4b2c0fc019b2667af845202059103f70d684d924a5dc0590469f825ca7d251d3"
  license "MIT"
  head "https://github.com/gopasspw/gopass-jsonapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "38d166ab9e6865363ebd2027c12d3665d9ad87df2509fb7e10a7763d73cb4526"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eee17fe1410861ea49e29cf62ca6ae75197dcebb95ee475732cf21238cbe15d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ffec0e354293aca84ea898cdfacfd882c33059cd8887c89735ec6299da9213e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de745a0eae2f3fa2137d28ddc07a071f6bea513feb9d4e8a771680fd7dcd8103"
    sha256 cellar: :any,                 x86_64_linux:      "29c3feb200e5ba74ba2841ff516d572bf4303f292f108ec9a1b8f96d02ab8f7a"
  end

  depends_on "go" => :build
  depends_on "gopass"

  on_macos do
    depends_on macos: :sonoma # for SCScreenshotManager
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
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