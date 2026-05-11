class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.38.0.tar.gz"
  sha256 "76714ec65a6a379d0d07977dfe1b5debd05ef3a3afb92a0b5cff421f19724f53"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33e00e4e9d9fbda26b9fced8ae2f98b28a46101931688efb0dc02a1575d72af7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "203b9ffe0fcad189e4eac84fe8b8c3f2312d41db54737151867c2956f2d9a348"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fbdff065e773e7c7cf975ac5aae667a7141105ceb1b65f6f66fd028e8b85fc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4888b58297e2f9ea658859bbdd70fa12ce6cd69a05e45394f6fed59f28eed56"
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