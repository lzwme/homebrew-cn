class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://ghfast.top/https://github.com/supabase/cli/archive/refs/tags/v2.62.5.tar.gz"
  sha256 "fce4f7c06d511e5e62ecf70eef183a1c1f21620ad5faf5dca0607abcfb08eb81"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac0947cc24ec6fba862fce0328eb92b029e2c762ff9e2fbcd394df08143879e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dce190b9d24a26d091a9317f27a9b93c4bf6d6ae46e769d24baaf5d2331cbd02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "595c2f1f882bcccc8bc030bd246c9d86c5b77ed70654c0a76a2c87c445a99d87"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7f9bc132b889b987dd4cc554928056edc71cf01e3dde8fe80f4db63b7a0cee1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0127a0eb4930efc55eee525f4f7ece95e44021b1df3d3db82334a71b7664cea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cac091ed4ef26fa9aca9838b96bf79da25e7184da67136d71d9b9a65f119eab0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/supabase/cli/internal/utils.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"supabase", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase --version")

    system bin/"supabase", "init", "--yes"
    assert_path_exists testpath/"supabase/config.toml"
    assert_match "failed to inspect container health", shell_output("#{bin}/supabase status 2>&1", 1)
    assert_match "Access token not provided", shell_output("#{bin}/supabase projects list 2>&1", 1)
  end
end