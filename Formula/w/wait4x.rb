class Wait4x < Formula
  desc "Wait for a port or a service to enter the requested state"
  homepage "https://wait4x.dev"
  url "https://ghfast.top/https://github.com/wait4x/wait4x/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "0c97d72d415b5969472225e0c75218cf505b49ad48a3204967a2483208b6d97e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5fa66564d017b8e357122ff5009fd17fc0325475de239b9a8565bf76a2ff188"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1847049b24cc7c55b4c6d20db27709f0d6da1b726327a9133a44b74fc8d9623"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "605957867f49289476e840e6232f38878a1cc428cd64c7722af29b9a814e503b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3c99e3882d0e538fc54b2480bda348bfdaf3b819e8be5176d3f8c0d79b7715e"
    sha256 cellar: :any_skip_relocation, ventura:       "17794d3a852d8e2ff42afd5209919ed007d708a81645f4587ff206ac59bf6776"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d71f9b7472396144ce818057aa2fda199b3971c1134b53245fed82996f03bfa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea2674b1e0a8f119d50e3c773096bff4136e253930829642e1371eca32328e22"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "dist/wait4x"
  end

  test do
    system bin/"wait4x", "exec", "true"
  end
end