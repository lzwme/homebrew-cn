class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "661adcabfcfe9ad2525c4e8b055937b3ba57feac6b8122e729e30ac0d81b92b2"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78b0690e1c425577d1dabbff4719933fbb04c34e2527afd8bd33b80727033878"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78b0690e1c425577d1dabbff4719933fbb04c34e2527afd8bd33b80727033878"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78b0690e1c425577d1dabbff4719933fbb04c34e2527afd8bd33b80727033878"
    sha256 cellar: :any_skip_relocation, sonoma:        "a62c8724c5f44885638652310a87bd192154ab62087c824723c2812ebeb3a9a8"
    sha256 cellar: :any_skip_relocation, ventura:       "a62c8724c5f44885638652310a87bd192154ab62087c824723c2812ebeb3a9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed2dd93cbeb3bedf08d2fac5f81233aeebaa4ce638b42495a88d7d833f210fd6"
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