class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.49.2.tar.gz"
  sha256 "ffa39b625416ac150587bcc93dfccac83c6eece6922b87ccc8d3000875ff3885"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c95fe93b056a0d2ef5d9d6bc6c18b225529948935fa1cfa6e18b664d49669edc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4258ff1254efca02b295724bbb227e7b2bbac1cf60c1cb5b3f3733059bf5ff9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88725fa17b15573b455c5a61fdc9c32731ffb9321f3f264f4c05827efbbec95d"
    sha256 cellar: :any_skip_relocation, sonoma:        "630b62fa60579efc6ef77d59c0f834caf51d41425c7f8b6621a99bf5a51aacd3"
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