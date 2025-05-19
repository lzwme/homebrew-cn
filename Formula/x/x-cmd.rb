class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https:x-cmd.com"
  url "https:github.comx-cmdx-cmdarchiverefstagsv0.5.13.tar.gz"
  sha256 "c0290a793f4a0cd90486060ff6fb46bab32aca933952a978e53c4bcb6d8e4240"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https:github.comx-cmdx-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7f40734d22785eb66b27f17dad72b45263dbc5e4fe67c111201ff9627daa408"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7f40734d22785eb66b27f17dad72b45263dbc5e4fe67c111201ff9627daa408"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7f40734d22785eb66b27f17dad72b45263dbc5e4fe67c111201ff9627daa408"
    sha256 cellar: :any_skip_relocation, sonoma:        "d69627e98bb04fe404ed06ceb317cdfc8b16e69b02dd809289fdfac45a41adb2"
    sha256 cellar: :any_skip_relocation, ventura:       "d69627e98bb04fe404ed06ceb317cdfc8b16e69b02dd809289fdfac45a41adb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80d2a84ad2f37ad3c760aea4afc61a314d29329ba0474f12f61c6102207f7074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80d2a84ad2f37ad3c760aea4afc61a314d29329ba0474f12f61c6102207f7074"
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