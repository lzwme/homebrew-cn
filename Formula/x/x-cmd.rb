class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "846e0816ec8687192070d6193a7aae53b91c6aaf465b65b8d09e70a774f540ee"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "345af163fea1ebb2ef1c3a748725b1da410020e2652d7a1a148dae0061e41aa6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "345af163fea1ebb2ef1c3a748725b1da410020e2652d7a1a148dae0061e41aa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "345af163fea1ebb2ef1c3a748725b1da410020e2652d7a1a148dae0061e41aa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "28efde08ffd981eba0c04b63f6668b89317a4f61512c2b97ae8c60348fd58614"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3062c15c2ce9de4187ab6f65595209047f14fa7fc88bcb5eb5af7d30e45ee15b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3062c15c2ce9de4187ab6f65595209047f14fa7fc88bcb5eb5af7d30e45ee15b"
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