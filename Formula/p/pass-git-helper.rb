class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https://github.com/languitar/pass-git-helper"
  url "https://ghfast.top/https://github.com/languitar/pass-git-helper/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "988738b5956cd4efbcc789500860c6dcc051e8a3918edd3fac4b8af69323730e"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34293382dc5c07dabe4cb6ae63ea9ecb8fc6bca9e1f2b971b6641e5be5ec2811"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34293382dc5c07dabe4cb6ae63ea9ecb8fc6bca9e1f2b971b6641e5be5ec2811"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34293382dc5c07dabe4cb6ae63ea9ecb8fc6bca9e1f2b971b6641e5be5ec2811"
    sha256 cellar: :any_skip_relocation, sonoma:        "e860373c32ae53181d6ca836aaa4ee19705271f2f4dc15dda8ef15687a50b6d6"
    sha256 cellar: :any_skip_relocation, ventura:       "e860373c32ae53181d6ca836aaa4ee19705271f2f4dc15dda8ef15687a50b6d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34293382dc5c07dabe4cb6ae63ea9ecb8fc6bca9e1f2b971b6641e5be5ec2811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34293382dc5c07dabe4cb6ae63ea9ecb8fc6bca9e1f2b971b6641e5be5ec2811"
  end

  depends_on "gnupg" => :test
  depends_on "pass"
  depends_on "python@3.13"

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Generate temporary GPG key for use with pass
    pipe_output("#{Formula["gnupg"].opt_bin}/gpg --generate-key --batch", <<~EOS, 0)
      %no-protection
      %transient-key
      Key-Type: RSA
      Name-Real: Homebrew Test
    EOS

    system "pass", "init", "Homebrew Test"

    pipe_output("pass insert -m -f homebrew/pass-git-helper-test", <<~EOS, 0)
      test_password
      test_username
    EOS

    (testpath/"config.ini").write <<~EOS
      [github.com*]
      target=homebrew/pass-git-helper-test
    EOS

    result = pipe_output("#{bin}/pass-git-helper -m #{testpath}/config.ini get", <<~EOS, 0)
      protocol=https
      host=github.com
      path=homebrew/homebrew-core
    EOS

    assert_match "password=test_password\nusername=test_username", result
  end
end