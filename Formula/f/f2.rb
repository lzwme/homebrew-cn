class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https://github.com/ayoisaiah/f2"
  url "https://ghfast.top/https://github.com/ayoisaiah/f2/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "44281ba6282fb80868ee4280b6722baaa111b7aeddc1d1c16a8b31df6c0971e5"
  license "MIT"
  head "https://github.com/ayoisaiah/f2.git", branch: "master"

  # Upstream may add/remove tags before releasing a version, so we check
  # GitHub releases instead of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a417a2ae5e3acab8511e915140a92db1f59dc7b5a2480ea997fda06978027877"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a417a2ae5e3acab8511e915140a92db1f59dc7b5a2480ea997fda06978027877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a417a2ae5e3acab8511e915140a92db1f59dc7b5a2480ea997fda06978027877"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a417a2ae5e3acab8511e915140a92db1f59dc7b5a2480ea997fda06978027877"
    sha256 cellar: :any_skip_relocation, sonoma:        "8728c49c827ef6a477909e7b52bb40e010ea234cbd83219360e50c127ebfc77d"
    sha256 cellar: :any_skip_relocation, ventura:       "8728c49c827ef6a477909e7b52bb40e010ea234cbd83219360e50c127ebfc77d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27e6ec44cf4cd42a33e12fd6c87392356c0edf2cb80e42031bea40a2cd398bea"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/f2"

    bash_completion.install "scripts/completions/f2.bash" => "f2"
    fish_completion.install "scripts/completions/f2.fish"
    zsh_completion.install "scripts/completions/f2.zsh" => "_f2"
  end

  test do
    touch "test1-foo.foo"
    touch "test2-foo.foo"
    system bin/"f2", "-s", "-f", ".foo", "-r", ".bar", "-x"
    assert_path_exists testpath/"test1-foo.bar"
    assert_path_exists testpath/"test2-foo.bar"
    refute_path_exists testpath/"test1-foo.foo"
    refute_path_exists testpath/"test2-foo.foo"
  end
end