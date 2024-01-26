class Optic < Formula
  desc "OpenAPI linting, diffing and testing"
  homepage "https:github.comopticdevoptic"
  url "https:github.comopticdevopticreleasesdownloadv0.54.0optic-darwin-amd64.tar.gz"
  version "0.54.0"
  sha256 "45d8e674000d6abbd7dcaf7ba50a27ee41e3b5b9a25b2ccb9f4c335c28d85d2d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "optic-darwin-amd64" => "optic"
  end

  test do
    system "#{bin}optic", "--version"
    assert_equal "#{version}\n", `#{bin}optic --version`
  end
end