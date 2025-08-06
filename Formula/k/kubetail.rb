class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://ghfast.top/https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.7.3.tar.gz"
  sha256 "dec91460260039f0c76f1c43395b1dd2d191bcdde77a48ddb1b5e3cf660e7718"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "642f31c03423a21d6256ce9d40d0683c209b139c5eab9733cbadfd72cc83d654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8c0489236ad350bf5f75bea7b4c076907e9431e29d51efafbfb13f71067097b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2004c81affca676498cca97f1e123ae35f0a2eb8c76ca8efd438b227b5f0ab9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f40adf0d1bd520236af289f46d3bfb19add854a478dcf2487955b4a39b7d63a0"
    sha256 cellar: :any_skip_relocation, ventura:       "df25f5823f3d63057a0b420d50ba4c821f586283f9a7ddcb2754905f929691f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d355aa7b55e1c7e6a3bb254f2c4f79b60cb5b2705a7aa4c3081b8246ec098298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f20709bcb642593fdf825581e39e2ed3f7f21e2a1350ff8d3b49483a1368b599"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end