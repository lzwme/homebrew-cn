class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https:x-cmd.com"
  url "https:github.comx-cmdx-cmdarchiverefstagsv0.5.14.tar.gz"
  sha256 "e0bccb4290c2eeef5ed97a963fbb8ed999d04eb842b6ee984e3f21007b1b46f7"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https:github.comx-cmdx-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "452aba0aa6a80ddee3a92bcdeb3c975916eb2fcecff9bc15408756d7aa7675ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "452aba0aa6a80ddee3a92bcdeb3c975916eb2fcecff9bc15408756d7aa7675ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "452aba0aa6a80ddee3a92bcdeb3c975916eb2fcecff9bc15408756d7aa7675ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c47b70f5a9d87789d3c065e5d2585c030893143584f3e5d40ce2a9581cf50cf"
    sha256 cellar: :any_skip_relocation, ventura:       "9c47b70f5a9d87789d3c065e5d2585c030893143584f3e5d40ce2a9581cf50cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d71a9b07d44b9e0893682bd1f3370b6f96fa4555a492392aea94cb3cc7eee6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d71a9b07d44b9e0893682bd1f3370b6f96fa4555a492392aea94cb3cc7eee6b"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix"modx-cmdlibbinx-cmd", "opthomebrewCellarx-cmdlatest", prefix.to_s
    bin.install prefix"modx-cmdlibbinx-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}x-cmd cowsay hello")
  end
end