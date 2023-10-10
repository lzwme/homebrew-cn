class Optic < Formula
  desc "OpenAPI linting, diffing and testing"
  homepage "https://github.com/opticdev/optic"
  url "https://ghproxy.com/https://github.com/opticdev/optic/releases/download/v0.50.7/optic-darwin-amd64.tar.gz"
  version "0.50.7"
  sha256 "c8b9b4c8bda719a33f6287bdd2a9cdf76b68094b19cf15c857bfcd6e5f172edd"
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