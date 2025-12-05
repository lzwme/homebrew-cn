class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://ghfast.top/https://github.com/supabase/cli/archive/refs/tags/v2.65.5.tar.gz"
  sha256 "3dd456363d9949f0f3a591c9cba62f744928228a8d99c469b7ea36dc243975df"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "325c27e6097a35c881b4d88826539d7b6a7739f8e490c2d42ad92b0c911df267"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "013d0a6236b19513909b45c2d3baa5fdf1922c41637565b8d298375ed5c94fcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "936972c794af29fdcfa586762ba9fcdbe99776b745fc48a7e683aca1c8cfd74b"
    sha256 cellar: :any_skip_relocation, sonoma:        "303e69bc3a3b824a554132d4abae4e003079ab47802cf3ecf3f7d7123b145485"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "332685d0e98fea00cb38e44b31efe0a3f1f42b32ab85d04c3b04be92eef88f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7c85017ac5773fc504839f3fc6d4a9b89950b373df3c69ec8c5d1ad3d369f5a"
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