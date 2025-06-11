class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.74.1.tar.gz"
  sha256 "ac894d0f16f78db34818c396aad542b1512a776b925a7639d5d5a30d205a103b"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26441d2a56fd1e51f7694ec4bd9c0480d31fde68a6e54ad7a0a89d09e61594f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26441d2a56fd1e51f7694ec4bd9c0480d31fde68a6e54ad7a0a89d09e61594f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26441d2a56fd1e51f7694ec4bd9c0480d31fde68a6e54ad7a0a89d09e61594f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "774ab42370fe3c535ff7ef4251ab9aa44c56c6c537784d192e9a7a22a0266bcd"
    sha256 cellar: :any_skip_relocation, ventura:       "0ed3d8a49edbaf4ebbe5a81951554addb2d31548415a65e0c58886bfd6344148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "608c1c9a78d993b8f410cd659374dbe3f48f09d019604ee3b110d8483f611e60"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    with_env(
      "GH_VERSION"   => gh_version,
      "GO_LDFLAGS"   => "-s -w",
      "GO_BUILDTAGS" => "updateable",
    ) do
      system "make", "bingh", "manpages"
    end
    bin.install "bingh"
    man1.install Dir["sharemanman1gh*.1"]
    generate_completions_from_executable(bin"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}gh pr 2>&1")
  end
end