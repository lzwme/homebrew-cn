class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://ghfast.top/https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.8.1.tar.gz"
  sha256 "7726d538b90e0cdc13026846d918715cf5d2dfff580fdf2a83f3b9ee9271b73f"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "101aad49ec810a04e5b1a38e1314ce1939f7a4730414806ce03051bf383b4a63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dd62ab9228bc4cc53d96c35bbf5a877d102f4dbfea9180a17e0ed75dae0431d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8620e4bc5b5e0ba98fb8b9cd4946cea53e3fc380acfd685f6580f2600292e904"
    sha256 cellar: :any_skip_relocation, sonoma:        "00cff9974c65306afbdeaae94d7c2f1b4e83d490bd2459e7a86c87dbcc56ec57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa79a5c4d650c633736f5035b839b6a47235bbc108f777700b9ec6e9026bc76b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e467edd8f1c7367da5ab566002ab3893d9998e8d2e56213c5c61dcd95532760"
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