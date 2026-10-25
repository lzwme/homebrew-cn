class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "fc578d218322f45dc8e4502d53016f58d379f555b215e0465b06d6cddbc58c52"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef6d102b3225858b4f79899965b50eff1ca1734734d2d50a12e41056f3c6e0ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef6d102b3225858b4f79899965b50eff1ca1734734d2d50a12e41056f3c6e0ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ef6d102b3225858b4f79899965b50eff1ca1734734d2d50a12e41056f3c6e0ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d9ea402f7fa4e0f78fd2bd74c02bc4ee5a42a375252812642cab877b3ed605aa"
    sha256 cellar: :any,                 x86_64_linux:      "5d12adb8b77c04910777c1ab6a2036ca04f5fd9c34c08cbc5a8b730eb88415f8"
  end

  depends_on "go" => :build

  conflicts_with "deja", because: "both install `deja` binaries"

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"deja"), "./cmd/deja"

    generate_completions_from_executable(bin/"deja", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deja version")
    assert_match '"schema_version": 2', shell_output("#{bin}/deja doctor --json --offline")
    assert_match "no matches", shell_output("#{bin}/deja search nothing-is-indexed-here 2>&1")
  end
end