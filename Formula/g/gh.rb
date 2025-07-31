class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.76.2.tar.gz"
  sha256 "6aee5afebdabd33f4c5e8604a9b7fa55e5bbac2a5cd36101cc221c990320c8b3"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faceba16a942f0ebb76e4da8aeeee624fc368613670f9a6a69debb029dfde0d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faceba16a942f0ebb76e4da8aeeee624fc368613670f9a6a69debb029dfde0d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "faceba16a942f0ebb76e4da8aeeee624fc368613670f9a6a69debb029dfde0d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "acf80a636d3c7fa24ff60381dae956755da5652459e6ecdb624a571f4c9f998e"
    sha256 cellar: :any_skip_relocation, ventura:       "cab3318da3492e9d0eb639609fc1f3e013e18de8d8d54b35bc3bc73220b85984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "580872233df14f7e1fad5489df249c1fcbd64d315cd46a004df39d3dcdcb16fb"
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