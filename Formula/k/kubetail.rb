class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://ghfast.top/https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.12.2.tar.gz"
  sha256 "e0ed9b0f9f1007715967a6305da97cfe0d2723fbb6c8eaed34b285032103340b"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd3dce2d67ab5b8e15fa3b2fca56e1f9a881040ede68301d820d5b790062069c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc8e82ca5fca733ee2176dd3405da541c52f85aaec315c3c330e4bac2ce688bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e52382930619c560d4641b762c8891d0fa174c1c66cad168736ec141c8d4cb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcf4c07801d4d2ef6ffb9bb2b68f0a76f9981b443df0d8f2154a57600d83fd25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "026ea045286f61e7f0ba9f17c4b1258f110fc0ca90ce2a8531ad19c57b65bcdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9ea62ca051c6478e16f6bb7652902d75841ebebd83e1ada29fab1e6ae83534b"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", shell_parameter_format: :cobra)
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end