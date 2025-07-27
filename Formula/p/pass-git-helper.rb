class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https://github.com/languitar/pass-git-helper"
  url "https://ghfast.top/https://github.com/languitar/pass-git-helper/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "3e90c567b4cb6223aaca270c853328a4bc9fe0c22b7d3eae06f443301e4c394a"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6446919f05a0f6f432fd8db7a472e16c997bd34e012eaa1f7d90d2042debb8a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6446919f05a0f6f432fd8db7a472e16c997bd34e012eaa1f7d90d2042debb8a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6446919f05a0f6f432fd8db7a472e16c997bd34e012eaa1f7d90d2042debb8a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a6a534472dc493515a3b87ba3df9b60b0c9e969cdc86cc61e7d2d04706dcc36"
    sha256 cellar: :any_skip_relocation, ventura:       "7a6a534472dc493515a3b87ba3df9b60b0c9e969cdc86cc61e7d2d04706dcc36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6446919f05a0f6f432fd8db7a472e16c997bd34e012eaa1f7d90d2042debb8a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6446919f05a0f6f432fd8db7a472e16c997bd34e012eaa1f7d90d2042debb8a4"
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