class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.76.1.tar.gz"
  sha256 "9a247dbbf4079b29177ef58948a099b482efef7d2d7f2b934c175709ab8ea1b6"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6219b5db171ef6b851d451292d487907908260a6d81ca32ce49515a26d931eb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6219b5db171ef6b851d451292d487907908260a6d81ca32ce49515a26d931eb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6219b5db171ef6b851d451292d487907908260a6d81ca32ce49515a26d931eb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "63d0d9d73d9c40de6df81b85eec02d6a02fd250370ebcfa1a6e9c5338ccd0bed"
    sha256 cellar: :any_skip_relocation, ventura:       "a51fff43f441ff97e66498bd1cd3c0b61c2fa46d95f2ca714022dfb10f414fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8755adbdeafc47479fe797e72de44961d8b23929a9da1993ac3f8e5e01b7028f"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    ldflags = %w[-s -w]

    # FIXME: we shouldn't need this, but patchelf.rb does not seem to work well with the layout of Aarch64 ELF files
    ldflags += ["-extld", ENV.cc] if OS.linux? && Hardware::CPU.arm?

    with_env(
      "GH_VERSION"   => gh_version,
      "GO_LDFLAGS"   => ldflags.join(" "),
      "GO_BUILDTAGS" => "updateable",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end