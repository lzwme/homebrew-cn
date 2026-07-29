class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.16.0.tgz"
  sha256 "151a76ab1d1c472bdefaf758a9dc5d2fb96953dd22fb63a2afb41b7addae8ce2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6867fbbffc9029bcf49b6aa27323ad0634f26f74df611879fd520461da9801fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6867fbbffc9029bcf49b6aa27323ad0634f26f74df611879fd520461da9801fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6867fbbffc9029bcf49b6aa27323ad0634f26f74df611879fd520461da9801fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ec2403f83e161f67b3465f2ce9187c0a9edce932c23a020031705acbcb99d58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dfa8c5809de88d470b8d9a2a439b16439993e3bdb29437c93d08102d0ad5df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dfa8c5809de88d470b8d9a2a439b16439993e3bdb29437c93d08102d0ad5df3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shadcn --version")

    pipe_output = pipe_output("#{bin}/shadcn init -d 2>&1", "brew\n")
    assert_match "Project initialization completed.", pipe_output
    assert_path_exists "#{testpath}/brew/components.json"
  end
end