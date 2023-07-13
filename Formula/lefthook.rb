class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghproxy.com/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "81c2b34ca7f708f2b9cad3e72cf47872cc7806a1f98ea2afa3058b5ad7e13566"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bd7b20f2153ed0e728bc3eb83fc8154716f5f43bb9cc3620c5f229a04f6cedc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bd7b20f2153ed0e728bc3eb83fc8154716f5f43bb9cc3620c5f229a04f6cedc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bd7b20f2153ed0e728bc3eb83fc8154716f5f43bb9cc3620c5f229a04f6cedc"
    sha256 cellar: :any_skip_relocation, ventura:        "99ad572553bbb80943ac1da002d9352ecdd4ae0925b388f893c7569ac38de6be"
    sha256 cellar: :any_skip_relocation, monterey:       "99ad572553bbb80943ac1da002d9352ecdd4ae0925b388f893c7569ac38de6be"
    sha256 cellar: :any_skip_relocation, big_sur:        "99ad572553bbb80943ac1da002d9352ecdd4ae0925b388f893c7569ac38de6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85caf973ec8d1e6b53bdce5135237f5b0ff6f99101d32caf3432e6828cb6cf1b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end