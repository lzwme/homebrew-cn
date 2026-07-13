class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://ghfast.top/https://github.com/abhinav/git-spice/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "d4292eff27c0530d4420534acdc603fc518ed0e4be41336588276d33a3397c7a"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77d54c38be80a1748448869902ce7f3d832a10b74bbecf8aef8402405ea1d6cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77d54c38be80a1748448869902ce7f3d832a10b74bbecf8aef8402405ea1d6cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77d54c38be80a1748448869902ce7f3d832a10b74bbecf8aef8402405ea1d6cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8f6fcfa4dabef06e498179a85efd7e9f0522d3e3637020f3c11913722bedd3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc510b9bcf801173cb196d123191baa9d292257a67de103ca6fc7ba38dce1135"
    sha256 cellar: :any,                 x86_64_linux:  "831fb6347ed90391afd1cde7b38760de6338b46ccc86124436f7e3cf179a3606"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"git-spice")

    generate_completions_from_executable(bin/"git-spice", "shell", "completion")
  end

  def caveats
    <<~EOS
      The 'gs' executable has been renamed to 'git-spice'.
      If you prefer to use 'gs', add an alias to your shell configuration:

        alias gs='git-spice'
    EOS
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"

    assert_match "main", shell_output("#{bin}/git-spice log long 2>&1")

    output = shell_output("#{bin}/git-spice branch create feat1 2>&1", 1)
    assert_match "error: Terminal is dumb, but EDITOR unset", output

    assert_match version.to_s, shell_output("#{bin}/git-spice --version")
  end
end