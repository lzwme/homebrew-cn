class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://ghfast.top/https://github.com/supabase/cli/archive/refs/tags/v2.67.1.tar.gz"
  sha256 "61dcf4b34dd2ef31caf6233964ff94575dbd5951951a47ce855672f7fb31ebe7"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ab763fae41ad35af84d3b2107a87392d06875c31134843a0c23a64a767b729e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e80e2557285ceafc11e64a15421e2951fcd2244f8ae3af548a1e33822372973e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a8432846003af0f72c099b50a30619ddd809964132450c120de5b162af33d9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "322cbcb68e3dd17cd3876d855bfa14b3ad23f3cb569696bcf634ae50c0c8e6d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0620eb70ed547e5ddfba83ff077becfce82c6d045841572ecd9f5098dce23c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b6f41b0e69f0a4b36cbd0d3672453c734c191abb2daf9194673def11cfdf501"
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