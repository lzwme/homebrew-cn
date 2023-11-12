class Optic < Formula
  desc "OpenAPI linting, diffing and testing"
  homepage "https://github.com/opticdev/optic"
  url "https://ghproxy.com/https://github.com/opticdev/optic/releases/download/v0.52.1/optic-darwin-amd64.tar.gz"
  version "0.52.1"
  sha256 "c25c7e843c35dd267467b10417f42346d3754e75deb594507b87607cf92ca95a"
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