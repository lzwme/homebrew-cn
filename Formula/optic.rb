class Optic < Formula
  desc "OpenAPI linting, diffing and testing"
  homepage "https://github.com/opticdev/optic"
  url "https://ghproxy.com/https://github.com/opticdev/optic/releases/download/v0.49.1/optic-darwin-amd64.tar.gz"
  version "0.49.1"
  sha256 "f3feddba221b1b810257f4aa2fc62466d05a3edfe4ebc5415775d80f61b31c1d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "optic-darwin-amd64" => "optic"
  end

  test do
    system "#{bin}/optic", "--version"
    assert_equal "#{version}\n", `#{bin}/optic --version`
  end
end