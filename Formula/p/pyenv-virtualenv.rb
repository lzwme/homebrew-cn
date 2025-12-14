class PyenvVirtualenv < Formula
  desc "Pyenv plugin to manage virtualenv"
  homepage "https://github.com/pyenv/pyenv-virtualenv"
  url "https://ghfast.top/https://github.com/pyenv/pyenv-virtualenv/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "ca032a714370c6d3d38b3e98cc0e4ded38619872a4662cb7b75cf37891751025"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv-virtualenv.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcb425dc1c8b15a5b9598cf46f35d159dc8d087b32fa48bd19080d1cf8b95fd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcb425dc1c8b15a5b9598cf46f35d159dc8d087b32fa48bd19080d1cf8b95fd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcb425dc1c8b15a5b9598cf46f35d159dc8d087b32fa48bd19080d1cf8b95fd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e565f6100925c5a14dcdd28e175d0438dcf2a3db1ee950ac8616200670ec484"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d93707c1e1765c830545192c6c24e94f823126b0f6830a9aca3bd7b1676df104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d93707c1e1765c830545192c6c24e94f823126b0f6830a9aca3bd7b1676df104"
  end

  depends_on "pyenv"

  on_macos do
    # `readlink` on macOS Big Sur and earlier doesn't support the `-f` option
    depends_on "coreutils"
  end

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"

    # macOS Big Sur and earlier do not support `readlink -f`
    inreplace bin/"pyenv-virtualenv-prefix", "readlink", "#{Formula["coreutils"].opt_bin}/greadlink" if OS.mac?
  end

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv virtualenvs")
  end
end