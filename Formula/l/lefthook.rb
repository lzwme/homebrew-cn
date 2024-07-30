class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.7.10.tar.gz"
  sha256 "a752618bd674f44c4ed11d2baf1c56836084b100050048670a0b36df2c6567a7"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa6287a903eee4960adab1d931e1baf4c2920d02a3860d9ef1a575f0343c5c2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faeec5bbf321ea77f5881dbccd2dde6094797a3bb6056125a8aed9224701babe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bc84f7ad59911d65b7600a58c70354b44a81cb34f96c66d850e0c42baf430c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "a34228400affa9dc12554697efd24a69a0091c1f43953448c0b674bb276dea96"
    sha256 cellar: :any_skip_relocation, ventura:        "1d7fe9ad742fbb3d42b127f6595d84c6240cbcf081d4ffc36fe730a7c303f85b"
    sha256 cellar: :any_skip_relocation, monterey:       "c754e1b12e98ead9000e471d27acb0729b0f6da8a6806c6da94466a60ad35b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd10f81b18ab3f676218ca98fc533bd5b23c8de2f0d962ae53aff06d0cd7f5e5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_predicate testpath"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end