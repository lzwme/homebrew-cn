class Optic < Formula
  desc "OpenAPI linting, diffing and testing"
  homepage "https:github.comopticdevoptic"
  url "https:github.comopticdevopticreleasesdownloadv0.54.13optic-darwin-amd64.tar.gz"
  version "0.54.13"
  sha256 "e474efb038e5d28aebb227291e647f798fce00bfef3c9fe91043bfaf3246b2eb"
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