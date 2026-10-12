class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://ghfast.top/https://github.com/amir20/dtop/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "04089af1dfdc3c37b961887caca9108a2ed7c70805121fdebfa6227b0f759ae0"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6780779a4175e690c0055794cca64e5f1e0da812a41de61060b867c31281d0c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a3c09fe7a64ecbd05ed0f1ef95d1cd4d9d71fc65017f1e9662d9620d026eaca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "135fbfcb47e8287d1a83cd877b6a715f6106ed2d5ed7ed31ab48436e8deb34e4"
    sha256 cellar: :any,                 arm64_linux:       "09ee829a50a11ba5049c759bddf6e6388e0f275f64c6049239806d52b552aed3"
    sha256 cellar: :any,                 x86_64_linux:      "e274cc5f82462499eb45ee8f3f013b88f836c73fa0bc8b7cb6978b264948eb01"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end