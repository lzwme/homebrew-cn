class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://ldomaradzki.github.io/xcsift/"
  url "https://ghfast.top/https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "ddeeec38a96f65596dead07cf85695e34410b9d989fbd0451bbd46477e0b9e55"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28e63c9a7272a1e7cba1014044ab5f2cbcb3da8678c4579b82b171b0014443ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5c24ab99aca31be54419af8aa8a5ed7a853e970afac403eb587b0e07849e554"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b0cfd05cc688d9a97accb453a0c3dfd434b310c6f8ff90b689bd298de101f61d"
    sha256 cellar: :any,                 arm64_linux:       "d96439e951ab9a8a56a8c348fb874a7dc34ae5682f23c1fcf2fe1afa9047d293"
    sha256 cellar: :any,                 x86_64_linux:      "7998a0b41774c551335513d3306d96e8df71011fd10d41a23ab460bf45d732a2"
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