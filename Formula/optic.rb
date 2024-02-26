class Optic < Formula
  desc "OpenAPI linting, diffing and testing"
  homepage "https:github.comopticdevoptic"
  url "https:github.comopticdevopticreleasesdownloadv0.54.6optic-darwin-amd64.tar.gz"
  version "0.54.6"
  sha256 "0cca118148b7ceeaa23e477ac83f4de478748eb3904c2a1e40e86c754a986975"
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