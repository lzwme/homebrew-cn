class Asccli < Formula
  desc "App Store Connect CLI to manage apps, versions, and screenshots"
  homepage "https://github.com/tddworks/asc-cli"
  url "https://ghfast.top/https://github.com/tddworks/asc-cli/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "584cee19cdbd69d459f895070a7c8f10cde1eccca873848e9deb9316a185eb9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99b7312e7b280be931760a2d2042971d8e58656edf196f34c6adf971a6d95c53"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dabd9a7386608befd12fc506428ba08b34e5ee0acc51c86103fea6ef0e578dd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7880023a6f053ee1b7261fd2a9b4a217ce1b497944f9ef82e09a1e506125c05"
  end

  depends_on xcode: ["26.0", :build]
  depends_on macos: :sequoia

  uses_from_macos "swift" => :build

  def install
    inreplace "Sources/ASCCommand/Version.swift", 'let ascVersion = "0.1.3"', %Q(let ascVersion = "#{version}")
    system "swift", "build", *std_swift_args
    bin.install ".build/release/asc" => "asccli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asccli --version")

    # `auth check` resolves credentials from the environment and prints the
    # account status as JSON, exercising real functionality with no network
    # access. Throwaway credentials keep the test self-contained.
    ENV["ASC_KEY_ID"] = "TESTKEYID"
    ENV["ASC_ISSUER_ID"] = "00000000-0000-0000-0000-000000000000"
    ENV["ASC_PRIVATE_KEY"] = "-----BEGIN PRIVATE KEY-----\nTEST\n-----END PRIVATE KEY-----"
    status = shell_output("#{bin}/asccli auth check")
    assert_match "keyID", status
    assert_match "issuerID", status
  end
end