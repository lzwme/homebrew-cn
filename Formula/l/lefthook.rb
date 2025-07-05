class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.11.16.tar.gz"
  sha256 "aa99bca23b9d840d8f465adf402d6dffadea6d84409e1342b6629eb995d36338"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6388a949504e3c57b3272d282756c0cd104d127e4c54e29b3517d4f38abfacb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6388a949504e3c57b3272d282756c0cd104d127e4c54e29b3517d4f38abfacb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6388a949504e3c57b3272d282756c0cd104d127e4c54e29b3517d4f38abfacb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "66b760819959a6944aae813bc7c9207e38b1974498823d799eacf07cdf54911c"
    sha256 cellar: :any_skip_relocation, ventura:       "66b760819959a6944aae813bc7c9207e38b1974498823d799eacf07cdf54911c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b7e6d95399a85f56b08aed1d3c38a379a649b2ee74c4aecb10f4cb67d1bf4e5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end