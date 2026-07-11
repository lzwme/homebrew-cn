class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.45.0.tar.gz"
  sha256 "2896681e5e1482a2e8ce17f0bca0ddbf456b7b64ff31d8d25757adf55b854b33"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dcde32a92873490566661149d543cff0219368c4dcafc2e4e9b4ff54388626a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dba2e98b4ad3939e2d54cb1cc467ea28a4f36440ef412a6112eda9ff5812dc41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94baf80c6f661be67189f2d716bbac3f11331fbdd2453d84467bc64dd044107d"
    sha256 cellar: :any_skip_relocation, sonoma:        "307c5ddd824da8c0f8da0a076b28a661aca27e0ff34bd86961d9535aabc96527"
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