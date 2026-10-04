class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.57.0.tar.gz"
  sha256 "d5bc2b79c985cd539cbe8b78fd19fec7f8da2083eeaaffdb8d8f52b8565113b4"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c046a3d322e87321144a0eb30b7b85a13acf170c469eff598f9f34d13e0c465"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1f0eec97934e75d7af70bafd6a2b8d3fa40c7f14e678bc0fe8423229801e55d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a3d96b38ca66118e9f515e36f6e87826aa7aee9fae3e23d5c7f144d0f48ab33"
  end

  depends_on "go" => :build
  depends_on :macos

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)

    ldflags = "-X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
    %w[analyze status].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: buildpath/"bin/#{cmd}-go"), "./cmd/#{cmd}"
    end

    libexec.install "mole", "bin", "lib"
    bin.install_symlink libexec/"mole"
    bin.install_symlink bin/"mole" => "mo"

    generate_completions_from_executable(bin/"mole", "completion")
  end

  test do
    # Point simctl at the CLT so the sandboxed Xcode simulator probes are skipped
    ENV["DEVELOPER_DIR"] = "/Library/Developer/CommandLineTools"
    assert_match version.to_s, shell_output("#{bin}/mole --version")
    output = shell_output("#{bin}/mole clean --dry-run 2>&1")
    assert_match "Dry run complete - no changes made", output
  end
end