class Optic < Formula
  desc "OpenAPI linting, diffing and testing"
  homepage "https://github.com/opticdev/optic"
  url "https://ghproxy.com/https://github.com/opticdev/optic/releases/download/v0.51.0/optic-darwin-amd64.tar.gz"
  version "0.51.0"
  sha256 "b07e32308ad6a9d4b073d09ba4d802628c3da165d05f7f132bf3106650855c36"
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