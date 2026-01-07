class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "4edb624e0c2ca1091d22584fdccd5958cad1655fe1910da99c2d459ae1540c65"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd88b39ff74b475ebce02b794bbcc7d31e51fe3d7b1839adc0bf2ff03682801a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd88b39ff74b475ebce02b794bbcc7d31e51fe3d7b1839adc0bf2ff03682801a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd88b39ff74b475ebce02b794bbcc7d31e51fe3d7b1839adc0bf2ff03682801a"
    sha256 cellar: :any_skip_relocation, sonoma:        "768af4278a32360d90aaa10a00f8c762320fc03cb7fd95c25e374d992f7c24ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "617b1f490d6153574eb8b3cb6a57b718cd8c570958da5216078cbbe8633b2363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "617b1f490d6153574eb8b3cb6a57b718cd8c570958da5216078cbbe8633b2363"
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