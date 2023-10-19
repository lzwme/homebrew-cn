class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://ghproxy.com/https://github.com/felt/tippecanoe/archive/refs/tags/2.35.0.tar.gz"
  sha256 "8e47775d7b8a7ce6a4779d1a70de0f0a683b3da231d09bb3c87d1d79101a665f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0557cb14ccf2db72494d45f234b7cceb01903e44560eed98e0a87546e6b85a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52dd84bd548707a7bb94963ab5aa517fd05cd44db8b5e4680e7756f20fcd4dde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27081b2bdd44eb3c280c3aa185378154765cb2c357d23ad056ae02f52aec9035"
    sha256 cellar: :any_skip_relocation, sonoma:         "920dda4f166d15b48b60a82a0b368b2bff0c89db30a32751c91178a3a6ebda7e"
    sha256 cellar: :any_skip_relocation, ventura:        "5052c796d63c3458cccf68a8faad79f909f47ea99e273802bc52aef520f229c0"
    sha256 cellar: :any_skip_relocation, monterey:       "f9d5f4213ce3af8843c538f821808227c2e8b991f2d9264d9c2ae53078100df0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "149b99ea8d95e847f2d6481ec87c1728fbf7c87e082a57a95cc95ae7f053d5c4"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<~EOS
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end