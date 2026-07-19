class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.13.1.tgz"
  sha256 "4b5da1ab9904ac1399a9e4182bf6bad0b487ced5b71b691f91f5a8a193481fe2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf84d714ccfa01099b9fc94ad6113caecf38a81f6e971f291e093ec9d13ca3b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf84d714ccfa01099b9fc94ad6113caecf38a81f6e971f291e093ec9d13ca3b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf84d714ccfa01099b9fc94ad6113caecf38a81f6e971f291e093ec9d13ca3b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d999e070ae11db93432373fe4d0d363a065bfd49bf3c7c0a42cb825be42976e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbb9fd758eb7e88e2e6a0ca59030654a7c5b6e4e9eacab6b6fdf90502c91af75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb9fd758eb7e88e2e6a0ca59030654a7c5b6e4e9eacab6b6fdf90502c91af75"
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