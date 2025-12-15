class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://ghfast.top/https://github.com/git-town/git-town/archive/refs/tags/v22.3.0.tar.gz"
  sha256 "2ded68b1eb1fe31ad0d54c23e1a1466bb906d199d0da70431d0ebcfc8c9fb453"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "062c9c262782918ae4da383578d86157aaeab09d7adf73cabb0ba76f8c0f1917"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "062c9c262782918ae4da383578d86157aaeab09d7adf73cabb0ba76f8c0f1917"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "062c9c262782918ae4da383578d86157aaeab09d7adf73cabb0ba76f8c0f1917"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f6f0c214cf860d7f9ceca8b504cdd85c716673e76f18c23a4b9424b82effed6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ef7f7917d1ca81ae2cd5dbe562b3d4b2f347d8c5b74cdcb35854a7d7cedd43e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e224eef9d7b6064e74ca54f18ac75db81971babf1c853e10a79400d51b98db08"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end