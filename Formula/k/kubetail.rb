class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://ghfast.top/https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.16.0.tar.gz"
  sha256 "1dd2ed3edfd5ff7b55dad85522d0f63e6e0afa847dc24da7091978b3c3ada9b7"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8433f079e497cfcd87abfd45b79c62b1002696fd75ace124004c907218522377"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5776e2d17b5a3f3a15351bfe1e87368902a6ff402731f4ce2e7647f0499e5db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4b533e19021725269edd701de8ae79a946459607078cb23ec23b4f98413de9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0ea92f006e03edc2f87fa876803448e76ba67d81fd254bb94bfc94bed889eef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "475d10a4bf45169b402f39e7eebbdc572ff8208b3e5019e6e88aa8cbe0c03ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1728a8b2c04700128b16647a8d7ecea7430d10a866a5c63834ccc8c9d72f3bf2"
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