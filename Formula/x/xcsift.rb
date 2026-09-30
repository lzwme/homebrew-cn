class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://ldomaradzki.github.io/xcsift/"
  url "https://ghfast.top/https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "0b8d3470cde17e78fd894291502cccd9b4a310574f4ca6e21c4c4bbe83ba76dc"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a7386c9fd69cf74b730faa05308f11bc0b46afe226c369864c01655f7c534b36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c3379c58df3d7c776af2a37b7a7ae487f513f445644a129348dea469e55d4f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "67afda547dbc030e488ae188d7159a8ecdab4ea4dcf59c7678adcba5e197afd6"
    sha256 cellar: :any,                 arm64_linux:       "0314d464b9f291e78bd9ca37404c192a3c946eff0b1777100c25d6d2271a2912"
    sha256 cellar: :any,                 x86_64_linux:      "fc4bed8b9ad6ee23631f59bda0a6a9f79bec9e8d31da69aa424065fe087a0914"
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