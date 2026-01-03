class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://github.com/vladimirvivien/ktop"
  url "https://ghfast.top/https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "857bbe49ee0942e3050836b5fb44d41c97c44fca0aa27b3e2a0c7db381558e66"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "965b3c0fab2d3c40e51a15148ce255bc2c7bbbb5ab0c06012331d3cd72f4864f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "471efd5f63a8ef823a37f54a59cf55b5f7fcd66fb9469d9752c1a1e592c1e465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0fd7bd1c569d0ce3928923e690fd271ff9765d341e6f1b422a443c80dff24a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ab98cef19bf4172ace8c053081931206fca8d59bcc32d162685c9639c684b55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5881e3f70b887d6c75b0283fe3cb8a40f962a32a1c6ef3fd85c704d94628cdb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e27109281d0a4d4c36a98f640c925e1820bc31394eb5a0181ced7727e700b55b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vladimirvivien/ktop/buildinfo.Version=#{version}
      -X github.com/vladimirvivien/ktop/buildinfo.GitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/ktop --all-namespaces 2>&1", 1)
    assert_match "connection refused", output
  end
end