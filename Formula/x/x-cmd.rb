class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "f469b1d278d70d8e7765ec83cedf8ebeb9a77484a8ad57cf155fa9b6dfb6dbdb"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccd26bd50a8634b8bdc18c1f5ba4f5e2e55720f72a0238d57a51aab3671c3e22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccd26bd50a8634b8bdc18c1f5ba4f5e2e55720f72a0238d57a51aab3671c3e22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccd26bd50a8634b8bdc18c1f5ba4f5e2e55720f72a0238d57a51aab3671c3e22"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4eef48667316c4152cc1373e68431f5264863c3cfa131a5221af0d077eddbdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61c4bcb8c10fe9dfa2e5450d64778979bd51f774f9e5ab1605bf631d9f20ffce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61c4bcb8c10fe9dfa2e5450d64778979bd51f774f9e5ab1605bf631d9f20ffce"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end