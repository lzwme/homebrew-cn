class GitGerrit < Formula
  desc "Gerrit code review helper scripts"
  homepage "https:github.comfbzhonggit-gerrit"
  url "https:github.comfbzhonggit-gerritarchiverefstagsv0.3.0.tar.gz"
  sha256 "433185315db3367fef82a7332c335c1c5e0b05dabf8d4fbeff9ecf6cc7e422eb"
  license "BSD-3-Clause"
  head "https:github.comfbzhonggit-gerrit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cf3c7193a5ccbff2562105efa2ad31ad3b17de050b28c9ab1f70fa99666469f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cf3c7193a5ccbff2562105efa2ad31ad3b17de050b28c9ab1f70fa99666469f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cf3c7193a5ccbff2562105efa2ad31ad3b17de050b28c9ab1f70fa99666469f"
    sha256 cellar: :any_skip_relocation, sonoma:        "01772c7bee5b9b90a0cec0c8d7db50674a0dbd6b92745539b906e8afd2151aa6"
    sha256 cellar: :any_skip_relocation, ventura:       "01772c7bee5b9b90a0cec0c8d7db50674a0dbd6b92745539b906e8afd2151aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cf3c7193a5ccbff2562105efa2ad31ad3b17de050b28c9ab1f70fa99666469f"
  end

  conflicts_with "gerrit-tools", because: "both install `gerrit-cherry-pick` binaries"

  def install
    prefix.install "bin"
    bash_completion.install "completiongit-gerrit-completion.bash"
  end

  test do
    system "git", "init"
    system "git", "gerrit", "help"
  end
end