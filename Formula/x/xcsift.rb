class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://ldomaradzki.github.io/xcsift/"
  url "https://ghfast.top/https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "df1a32aab7df3dd7df428909042efe65fa254cfdf6638b8d1f105dd3d86233c6"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0349ce7a5aad0614659162d560fe82d5fa406a3bfe69be6975ca90f7d1384620"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "88d7a26071ac354ea56647c409e7cd2ba39dcb26e51f2e455398d6417290ea03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e695031baadd33bf209713016a067b2fffa4da0ef218cfc96bfa1b6698cfce4b"
    sha256 cellar: :any,                 arm64_linux:       "095c0d8f59b762a6263f130843f405eeb8c50b6fad94a8fbb42897bf4d3cb85f"
    sha256 cellar: :any,                 x86_64_linux:      "04c3e0260550045982b7740f4839de3c9edc983d7859f170d00c378be1718905"
  end

  uses_from_macos "swift" => :build, since: :sonoma

  on_macos do
    depends_on xcode: ["16.0", :build]
  end

  def install
    inreplace "Sources/xcsift/main.swift", "VERSION_PLACEHOLDER", version.to_s

    system "swift", "build", *std_swift_args
    bin.install ".build/release/xcsift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcsift --version")

    output = pipe_output(bin/"xcsift", "Build succeeded")
    assert_match "status", output
    assert_match "summary", output
  end
end