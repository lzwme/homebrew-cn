class Optic < Formula
  desc "OpenAPI linting, diffing and testing"
  homepage "https:github.comopticdevoptic"
  url "https:github.comopticdevopticreleasesdownloadv0.55.0optic-darwin-amd64.tar.gz"
  version "0.55.0"
  sha256 "60784827263a3be80cf8e1a91d33a7bc454629f3eb0028583ba81ebf140e239c"
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