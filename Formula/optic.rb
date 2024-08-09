class Optic < Formula
  desc "OpenAPI linting, diffing and testing"
  homepage "https:github.comopticdevoptic"
  url "https:github.comopticdevopticreleasesdownloadv1.0.0optic-darwin-amd64.tar.gz"
  version "1.0.0"
  sha256 "a74c45cf3d6d99b636d76fdb8bad01e8f69c12eb92f8a42cb2514363f87d4427"
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