class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https:docs.iotex.io"
  url "https:github.comiotexprojectiotex-corearchiverefstagsv2.0.8.tar.gz"
  sha256 "405da9c97666daea13a96c383403edd950c2d30f727745d38254a4665158fd93"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a013fcd3b2d5bfede3208def0a5df67c8fed48045681b6c8ee7f5530e08465d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "459c901932e19145555c0bd30ca0b7c9e0b3c76fb6c4c5ff4089cf3eee7a9e19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a690ea6b13ef1e59644b20842c338ab15577d455d7aa61173c64aef3a99bcce"
    sha256 cellar: :any_skip_relocation, sonoma:        "e31a6fc5e22a43881994e929cec4ddc95a78ccdf329e0e4bbaa6c752e28821bc"
    sha256 cellar: :any_skip_relocation, ventura:       "0b8148d967d267ebcb1f977af86a1004aaaa07e68edc63e1581212f52ed4d622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea759f96674d98cc866a2fd60f64599592913b2ac5d3f9f1108db0f0d0553b8d"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "binioctl"
  end

  test do
    output = shell_output "#{bin}ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end