class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.17.0.tgz"
  sha256 "d889b2190ebc46235a6f8ec42e38c7f80dabb4a115646b91352c47b235211ee1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3894d45cded34252a784795cc646ac067a93a7d08b0583815d004e9cac3779a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3894d45cded34252a784795cc646ac067a93a7d08b0583815d004e9cac3779a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3894d45cded34252a784795cc646ac067a93a7d08b0583815d004e9cac3779a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "90cf1044ff6ee9d6bde938734317ba5c76860aa08017273cbe15f92a70ea267b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf3333c56a917e09f6e31606b6d20944f3140a082261e3af7f48c14f12f5b395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf3333c56a917e09f6e31606b6d20944f3140a082261e3af7f48c14f12f5b395"
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