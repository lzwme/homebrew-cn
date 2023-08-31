class Optic < Formula
  desc "OpenAPI linting, diffing and testing"
  homepage "https://github.com/opticdev/optic"
  url "https://ghproxy.com/https://github.com/opticdev/optic/releases/download/v0.49.4/optic-darwin-amd64.tar.gz"
  version "0.49.4"
  sha256 "73b653df4e1bdc3bbb490f448ef0e406a3ecbb2e64108494d7abac410c9f6a3a"
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