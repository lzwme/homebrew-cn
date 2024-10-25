class Optic < Formula
  desc "OpenAPI linting, diffing and testing"
  homepage "https:github.comopticdevoptic"
  url "https:github.comopticdevopticreleasesdownloadv1.0.4optic-darwin-amd64.tar.gz"
  version "1.0.4"
  sha256 "ded14a444bae05b8587b8918b1a5c93e2c2df9f35c658b0adf5317735bfaec56"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "optic-darwin-amd64" => "optic"
  end

  test do
    system bin"optic", "--version"
    assert_equal "#{version}\n", `#{bin}optic --version`
  end
end