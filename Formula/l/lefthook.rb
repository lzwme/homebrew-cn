class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.11.6.tar.gz"
  sha256 "f573e9b8f08e8b2e26a820dc54f245d3ff9464d3edf3dd9e9b1276401be680aa"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1abe42c05eb03d52d299c1542104589ececad66d37e83375c4a8b40e2f02f96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1abe42c05eb03d52d299c1542104589ececad66d37e83375c4a8b40e2f02f96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1abe42c05eb03d52d299c1542104589ececad66d37e83375c4a8b40e2f02f96"
    sha256 cellar: :any_skip_relocation, sonoma:        "a885f5b5c0d8f3f3e9f8f4d276547cd848e0cf8fac801c323e4547596b5c034a"
    sha256 cellar: :any_skip_relocation, ventura:       "a885f5b5c0d8f3f3e9f8f4d276547cd848e0cf8fac801c323e4547596b5c034a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcb582ffcdd5add788a02428d13e0fb4d764b23b2a5d121ee54e3e468bc9a385"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_path_exists testpath"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end