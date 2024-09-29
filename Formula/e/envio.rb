class Envio < Formula
  desc "Modern And Secure CLI Tool For Managing Environment Variables"
  homepage "https:envio-cli.github.iohome"
  url "https:github.comenvio-clienvioarchiverefstagsv0.6.0.tar.gz"
  sha256 "1a827ecee53299e060a2ce45cbb2215f3ca6c48fc5baf05b2d5a46018fb09bc7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comenvio-clienvio.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6f9c00fe287c8ebf79a3ebf056fc75920e6432c9f43670986d5030785e9f19c5"
    sha256 cellar: :any,                 arm64_sonoma:  "09379bc1ca4cf919ccc0cd4805d71751a592b6cd6e9e02aba5801110e9a863c4"
    sha256 cellar: :any,                 arm64_ventura: "d6ba9b0de7405d4746fc3a013b3c4f61b03c4309e411d7d2bce9f67e144a750a"
    sha256 cellar: :any,                 sonoma:        "4799418cc8413d5234ed4cd932c43948e68bfe81fdbb0de3edaaa5facad29fde"
    sha256 cellar: :any,                 ventura:       "061f3651361cdee4e101a665217b8b56d0f299a0c0add00d6181ab8cec5c1c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5fb8bf937cbf6f79d55c7ee9d42bd0d9ec51206c59038f0685f51c42b260be2"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gpgme"
  depends_on "libgpg-error"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Setup envio config path
    mkdir testpath".envio"
    touch testpath".enviosetenv.sh"

    (testpath"batch.gpg").write <<~EOS
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

    system Formula["gnupg"].opt_bin"gpg", "--batch", "--gen-key", "batch.gpg"

    begin
      output = shell_output("#{bin}envio create brewtest -g #{testpath}.gnupgtrustdb.gpg", 1)
      assert_match "Profiles directory does not exist creating it now..", output
      assert_predicate testpath".envioprofilesbrewtest.env", :exist?

      output = shell_output("#{bin}envio list")
      assert_empty output

      assert_match version.to_s, shell_output("#{bin}envio version")
    ensure
      system Formula["gnupg"].opt_bin"gpgconf", "--kill", "gpg-agent"
    end
  end
end