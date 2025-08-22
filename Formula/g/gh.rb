class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.78.0.tar.gz"
  sha256 "9eeb969222a92bdad47dded2527649cd467a6e2321643cc30e1f12d00490befe"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "100a42a5352dfb76c01872ead02b29c38608ff05e4101265172d2fae10df74bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "100a42a5352dfb76c01872ead02b29c38608ff05e4101265172d2fae10df74bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "100a42a5352dfb76c01872ead02b29c38608ff05e4101265172d2fae10df74bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b709ac98289122fdc1dbcc8a4ff5866fd47c3b0849879a542c93175698cc406"
    sha256 cellar: :any_skip_relocation, ventura:       "06972d10ce5be93c27e229a773711ebe00f5e5965327ea71a6a8974d66478a69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f44d5467727bd0bda7d4f54304fdb7d848e531202a0449f54bb66461512b3aa"
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