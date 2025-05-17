class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https:github.comayoisaiahf2"
  url "https:github.comayoisaiahf2archiverefstagsv2.1.1.tar.gz"
  sha256 "0722082db8e4dddde350104041b1454592dcf0b0eec884f792b3d370ae535b42"
  license "MIT"
  head "https:github.comayoisaiahf2.git", branch: "master"

  # Upstream may addremove tags before releasing a version, so we check
  # GitHub releases instead of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc703caa1863c914db2c8772bbe0c088b7af13a2445aac46f24ac94276a863cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc703caa1863c914db2c8772bbe0c088b7af13a2445aac46f24ac94276a863cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc703caa1863c914db2c8772bbe0c088b7af13a2445aac46f24ac94276a863cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9102d2012718cf03d4db3104f51a371f5d266237a36c981aaa10fb816e0a55d5"
    sha256 cellar: :any_skip_relocation, ventura:       "9102d2012718cf03d4db3104f51a371f5d266237a36c981aaa10fb816e0a55d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0ceffea79c3edf42ed8a11e57f46a11c10d0f9df2d15f511ed58ac701f85435"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdf2"

    bash_completion.install "scriptscompletionsf2.bash" => "f2"
    fish_completion.install "scriptscompletionsf2.fish"
    zsh_completion.install "scriptscompletionsf2.zsh" => "_f2"
  end

  test do
    touch "test1-foo.foo"
    touch "test2-foo.foo"
    system bin"f2", "-s", "-f", ".foo", "-r", ".bar", "-x"
    assert_path_exists testpath"test1-foo.bar"
    assert_path_exists testpath"test2-foo.bar"
    refute_path_exists testpath"test1-foo.foo"
    refute_path_exists testpath"test2-foo.foo"
  end
end