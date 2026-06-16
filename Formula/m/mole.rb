class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.43.0.tar.gz"
  sha256 "22de731d20d6adecdfd5c81fb71a5be3f3a2e3b53ef0bc3c14418fb5307998cc"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa773c1c56b7933ce71e8b7bf38fe4a1f4eda5b476701234435ef1e9bcb90183"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64191640abd18f2610ca3da810d0457c73bcbb93261ac04a49779228bd07bbeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec1f3dfc9bd18f65e41ff51a4b4c5103cd37fb71a150aad1c178d02e5425f60c"
    sha256 cellar: :any_skip_relocation, sonoma:        "045af3356be933a50b09968a3a64dea4987ac574938e50fc8db84e62584832e7"
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