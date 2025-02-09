class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https:github.comzk-orgzk"
  url "https:github.comzk-orgzkarchiverefstagsv0.14.2.tar.gz"
  sha256 "51956ab37595f2c95d97594e1a825d35de9be0c31af2f32f2e2d4468b7b88e0c"
  license "GPL-3.0-only"
  head "https:github.comzk-orgzk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f16805068eb80ed2f67a4b54e2b17d5d627e2a2a70fd19b6c3289e122c1e0a76"
    sha256 cellar: :any,                 arm64_sonoma:  "f5ae5d324c4ffd2e402091ce39737cb757e99bff7f42ad711160d5183dce93df"
    sha256 cellar: :any,                 arm64_ventura: "8884aa15091691a698705dfb01cdb9ab586516014c822fab80447b9a5fa5d89f"
    sha256 cellar: :any,                 sonoma:        "78027aae1bc427c8ab5b0657d455cbfb670b998137eaf492a2a09699323ef620"
    sha256 cellar: :any,                 ventura:       "5a66bc9ec38fa76978bddcd9acde239373131293cabbbe07bdc2f1eddc7be4a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5662aa1334225f191db6adf80d805094bf489cfff6a58fb623a09820eb02e8c"
  end

  depends_on "go" => :build

  depends_on "icu4c@76"
  uses_from_macos "sqlite"

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Build=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "-tags", "fts5,icu"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}zk --version")

    system bin"zk", "init", "--no-input"
    system bin"zk", "index", "--no-input"
    (testpath"testnote.md").write "note content"
    (testpath"anothernote.md").write "todolist"

    output = pipe_output("#{bin}zk list --quiet").chomp
    assert_match "note content", output
    assert_match "todolist", output
  end
end