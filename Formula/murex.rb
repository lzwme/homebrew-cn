class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://ghproxy.com/https://github.com/lmorg/murex/archive/refs/tags/v4.4.8000.tar.gz"
  sha256 "8910c80a646caed3d0cbf0df25b58d754638350745d771912e7237e7136617f5"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bb926844d20e32ae77356a72a73aff40629f674c577cab8de1ba4a4a88dfc73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29bd91c5aa3164f56ac3da5d42f987e572b2ef18cbd15877ca7fccb3f8924abe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b0673495e6649a370547eb69793003e19ba4dea38917e2c80e3e4f8d999fded"
    sha256 cellar: :any_skip_relocation, ventura:        "8335a80933016864765879515c5796d2d8977817c7bc878653209d1f5df13a2e"
    sha256 cellar: :any_skip_relocation, monterey:       "7dc3981812546bdfe042cc2d6d22b5af4dfcc3b9f87124136cff344987f45c0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "47cbc267cfd3c8361c83627748d50836a900999ba81272b3e37ddb09bf04ddf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2958d7b01eee590de97c13bd7a5ca67e6e58550d5b6c89d2f80c8452d1056057"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end