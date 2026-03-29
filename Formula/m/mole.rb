class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.32.0.tar.gz"
  sha256 "f854128e209b787f3a12f257339bc8c27667047c88d61dd74f6c75e52b3a450b"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1029e0f00ec514c688e9ec33007a52778af8dc9d2d51cce2605095166caf7cdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b40d206e85a72a3a3bd2b3edcdd35a1cc7ed152f1d47e85786933f0ea1f100b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "096b7e0064206b947c81e2acc0d0f8ef975cf426ecefaf91d6800c844834b53d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7ec322d0b48aa7ef676977a0d074e625d86bc85fc6a24c44c3b396405139db5"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
    %w[analyze status].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: buildpath/"bin/#{cmd}-go"), "./cmd/#{cmd}"
    end

    inreplace "mole", 'SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"',
                      "SCRIPT_DIR='#{libexec}'"
    libexec.install "bin", "lib"
    bin.install "mole"
    bin.install_symlink bin/"mole" => "mo"
    generate_completions_from_executable(bin/"mole", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mole --version")
    output = shell_output("#{bin}/mole clean --dry-run 2>&1")
    assert_match "Dry run complete - no changes made", output
  end
end