class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.11.8.tar.gz"
  sha256 "811b658fd8335a57296d9892f334a76b286b2c8b39cead33e9c0942440f8177b"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b671623b20465af0e9445f2ce82672ef37d12afcb7c5cb35e7c7387e3d964ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b671623b20465af0e9445f2ce82672ef37d12afcb7c5cb35e7c7387e3d964ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b671623b20465af0e9445f2ce82672ef37d12afcb7c5cb35e7c7387e3d964ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8a11476c626ff33b98acec5a922b464a8238ef6b4639775c76b0fcfdbabd03e"
    sha256 cellar: :any_skip_relocation, ventura:       "e8a11476c626ff33b98acec5a922b464a8238ef6b4639775c76b0fcfdbabd03e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "316306c7fbc8fc2d29b3678cfac692fc3b6ffdcd554fe2396c79bf508b377eb1"
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