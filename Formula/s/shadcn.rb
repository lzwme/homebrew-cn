class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.21.1.tgz"
  sha256 "59538fbf55a74e3492d8b66595af0662878b9fa3b6f114564ebe325211cb7932"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d0595043c1b781f6356703cafaddb720ad97eb899167d44655de92cda31a7ec3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d0595043c1b781f6356703cafaddb720ad97eb899167d44655de92cda31a7ec3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0595043c1b781f6356703cafaddb720ad97eb899167d44655de92cda31a7ec3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "359369953abef01cf41ca7e105be965a2c09edf690e6f8f716660db3134db1b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "359369953abef01cf41ca7e105be965a2c09edf690e6f8f716660db3134db1b6"
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