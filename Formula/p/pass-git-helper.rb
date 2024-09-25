class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https:github.comlanguitarpass-git-helper"
  url "https:github.comlanguitarpass-git-helperarchiverefstagsv3.0.0.tar.gz"
  sha256 "3b0cda7a5eae2e93cc1ccec0ea02716db5a2ce3105c6d631f20fa20152b7a163"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e09e51c4bb4f74a853d43b12ec2b1f6f700c76a3e41c8674c9e40aadad58813"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e09e51c4bb4f74a853d43b12ec2b1f6f700c76a3e41c8674c9e40aadad58813"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef6bb158d8dfc0bb5de0253bd4bb1847f9a3af05de9d9bfb32f71499ef1c3c31"
    sha256 cellar: :any_skip_relocation, ventura:       "ef6bb158d8dfc0bb5de0253bd4bb1847f9a3af05de9d9bfb32f71499ef1c3c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a78a4695879b2336e70ae38c98c86c89c488832e0e34f41374b12bad29aaf9"
  end

  depends_on "gnupg" => :test
  depends_on "pass"
  depends_on "python@3.12"

  resource "pyxdg" do
    url "https:files.pythonhosted.orgpackagesb0257998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Generate temporary GPG key for use with pass
    pipe_output("#{Formula["gnupg"].opt_bin}gpg --generate-key --batch", <<~EOS, 0)
      %no-protection
      %transient-key
      Key-Type: RSA
      Name-Real: Homebrew Test
    EOS

    system "pass", "init", "Homebrew Test"

    pipe_output("pass insert -m -f homebrewpass-git-helper-test", <<~EOS, 0)
      test_password
      test_username
    EOS

    (testpath"config.ini").write <<~EOS
      [github.com*]
      target=homebrewpass-git-helper-test
    EOS

    result = pipe_output("#{bin}pass-git-helper -m #{testpath}config.ini get", <<~EOS, 0)
      protocol=https
      host=github.com
      path=homebrewhomebrew-core
    EOS

    assert_match "password=test_password\nusername=test_username", result
  end
end