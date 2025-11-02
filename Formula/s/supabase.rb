class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://ghfast.top/https://github.com/supabase/cli/archive/refs/tags/v2.54.11.tar.gz"
  sha256 "fe92b944034bf4fe51b42d82b247cd0a6334311a81ac9c71190a433c042c2dfc"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91e055b5b8210f14427fdfc4963410863f06c200d6ace6eb53fda7d08853995f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62bd8b7a78df2cfb504252a4643a0e39712d7628e28c1b50c02791dcae97a1b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f31a62e41c445244629741c7da897420c135dd14b94b986dc7784df9d61cc219"
    sha256 cellar: :any_skip_relocation, sonoma:        "56becb6265dcb0e7bbd8bb2170f13cf8409fb0543e0fde5fb8ba2b971be42623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "000d00b057fa16bb70b133983375edb6aca0b4288b03bddc7837ccaad59c16d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80ce5b8062a4293d2916436169afd0a6390f28dd38d62895c2ff438d27632c7a"
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