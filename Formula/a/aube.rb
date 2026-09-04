class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "b51611ca269dba88d75056e97bfb9673e3c1c3ac822216aa56eeff49f299487d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10230333001eb4c492b643e383cfffedc9069efe419948232721bac756ba5096"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a780d73ad51f2451672345835c0913f7f93be608835724f65dec9401c93f9da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caa09122b93e595bd6ec97ace11d8541371c416b5a4cf05cbfc6bb48763421be"
    sha256 cellar: :any,                 arm64_linux:   "1716e46d6cd4efa82cb98fd912e9f38fcd5b22a3a2f5a0f59c3d9afe7ceb4da4"
    sha256 cellar: :any,                 x86_64_linux:  "d48d0f0a2da6997f7004d7e9d083d6cd3af3fdf57d0c8a833d9213ab31ad9ed6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end