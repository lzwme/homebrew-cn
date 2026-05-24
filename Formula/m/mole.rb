class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.39.1.tar.gz"
  sha256 "5f4b136481cef9db678629392a3f62c2dbdc9cf9edab5449f8b2bea4842717b2"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "544ac5bc6e417a0b9cbda5af3758da3e8eece8422c3ab74d0bdca0b96c24099c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86a35c7fbb888ec3b1e92b8ae4eb600aa19fede70c43cb579fcd97b3d1800857"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fd3dbedc607e0350c013f81cf1230d92533e395c731c77bd0dfbc72b1398ec9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e05eb1687243ab3657a1eb955866793cd6663e39daeecf8a6af04fa1a6171b26"
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