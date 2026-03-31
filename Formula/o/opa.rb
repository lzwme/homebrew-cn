class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "1d68813fe71025bb7730aca44221543a98568965366a4d197a2d2d97de8ad234"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2da18aa7a40ae7c3c0f8066389344023451f6a30e35cf2395fe8ef750c326249"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1698c00fa2656b843ed9c2dbc991e5f495a4953a65dbbd757b4ac725e4b494b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c5eeccf7aab12f8bd475b97c7e907db131ba5910421d7a35b829a9cbc0ad69b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a68139cef87cedf4e136a05c899d77274e881bc9aabe2470d539315dccddb0c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98aae3dd3febea27133ca1e209423a6a63902eed02b039eb4aa934ee8b3daf86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "025be8bae4e8cc780859d6ba64927b90e3928ebfbc9809bc8f19fb131b0537a3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
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