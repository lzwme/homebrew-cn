class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "97e191b89e415ac3163b8a5e5d9d757a2e01266d67c2d02730852d566b7a1089"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2425adb472617c295b2f24e93d406c4843eef2293014eae54470fbceb5f6cc64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2425adb472617c295b2f24e93d406c4843eef2293014eae54470fbceb5f6cc64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2425adb472617c295b2f24e93d406c4843eef2293014eae54470fbceb5f6cc64"
    sha256 cellar: :any_skip_relocation, sonoma:        "35b37c603eecc7d4a515223738a8962b8781a4b9ef0c0a8520b332daa7784bfb"
    sha256 cellar: :any_skip_relocation, ventura:       "35b37c603eecc7d4a515223738a8962b8781a4b9ef0c0a8520b332daa7784bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ebf405fd99344dc19986a64cc717a5efd79bcf799b1a448f6bc4f6776d763c1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end