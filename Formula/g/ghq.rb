class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.9.3",
      revision: "7caa68bcd008a8bc05a862d5dc1c2063f15ba043"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f81cfe79276053de4ae6d9686cbcbe6c83c6a200609aa861ee4cbb52258a2ed1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbff098be3b21ac630ad9d7d57a0ebd099b9f605a54701670165aba623fcee20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e63eb5c1740c3516ac4114366ac0d64f436fa12a9a81563335df40d1d820a120"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ccafcaf62c6ba98851cb8fd11249b5b8045c231177b5ed65a341a8dddbdccfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa0c4937f58ac58e031e22addeb63c57d40d88c2b364acb4e9efa7a2d39e4e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "733e3aa4a934f2fa18b36bc72f2426bc743de8fd28078e5110cd6726751c4e83"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    fish_completion.install "misc/fish/ghq.fish"
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end