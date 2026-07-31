class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "eab3adb9c1ffafade0167b4eece7a643eac2270da6abeda0772896034d174abe"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaab2baf55271d55a8ac30ff332a05fc51433ef019209461a7fb6f1e03a32437"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e0779335b5bf9e7ba685e1aa84b632e8593330ac8bb3a7a1a24be8afcc54eef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97555107eb300425fdaf91af600b1ff9e27f399507cb4161d86ff681dc3240e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d141f1c3fa877bdbd7a5244258c7a6ab1e70f0a53659aed6986e5a582619a779"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "773e1027cc02b6d1e22bf77b4630912c683ce0e9d464708e50001903fe448bb9"
    sha256 cellar: :any,                 x86_64_linux:  "439e94ce69ce1b971ea92625cd890b2a220f2f2edda1bd1d6546a9409e392183"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/open-policy-agent/opa/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end