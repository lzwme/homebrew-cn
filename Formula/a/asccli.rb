class Asccli < Formula
  desc "App Store Connect CLI to manage apps, versions, and screenshots"
  homepage "https://github.com/tddworks/asc-cli"
  url "https://ghfast.top/https://github.com/tddworks/asc-cli/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "992a63738fb2624f20610090b5b2340add43e9d916e4c43cf4d83ed23019db61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd4a8a6954b3d0825059ae12e06688cc971b9264e85579d2727a32fc46f60bbd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a888927350b2ec9eb5f4acecaffe48572630b9cec1e3fe4951eada84a837a58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c522bff372ac6baf927bce46ea8316a3c66ab15d3637932520d981cb8fbf17cc"
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