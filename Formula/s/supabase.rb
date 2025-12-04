class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://ghfast.top/https://github.com/supabase/cli/archive/refs/tags/v2.65.2.tar.gz"
  sha256 "1fc1353ac38ec99a5f46a8b98348b18f1edec6b0e9e9b982d7c440cfd79a08ec"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8e7bdae87a5e5273313412b84fa4983df394d045b6af93f869a65536881434c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af755e32e3750618ea630b3c4c5328091e22d7aac768bd302c173b70456ef4c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a31431d04c26a997fb16ab387cd3d56a5eea93d31edc0b6d9ca5212e0b61dea2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d292723e44387ecd0496506ac5c1584f54a4e84e4ff018cb8f5718acd7741de2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06abb6e9ab9a03722b57002eddfa60e596ecc22da1d0f9d2d588525a00a7de74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06d6bede64e8039ee2e2a0f6332e331c503322dccc8553bb1eb927d398b7b391"
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