class Optic < Formula
  desc "OpenAPI linting, diffing and testing"
  homepage "https:github.comopticdevoptic"
  url "https:github.comopticdevopticreleasesdownloadv0.54.3optic-darwin-amd64.tar.gz"
  version "0.54.3"
  sha256 "fb8bcd3cbeb171fbbc98239f6518fdd4b1998ba55d1dd7625e0f9062e8f731ea"
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