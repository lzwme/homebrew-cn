class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.49.1.tar.gz"
  sha256 "1bc87b173960b2bb5d39c26333403cd52f7d9caeffb6e43f2f44018fa12515bf"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e94db500f8ec7db4dc0f2d9f6e963847d8a657f7a459cff832a446ac9b18ecdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08ffc55ff3b0c59676b336a1773cf709132260bb55569942676592ff9dbf0b6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d09ac08a199d79adac6aae88a76843a7a6428daacf11f9fe85501423a4eb1287"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a89036e8c37f27c2aa71b5a90479751989104376a4fc06e6f49b56fc238be8c"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)
    ldflags = "-X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
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