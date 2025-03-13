class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.34.0.tgz"
  sha256 "5be3306ad361ff67847a037a90c58b9b890782a42fb88f6b9b84fa23dd72d85a"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "4e3038b264d38853482ad917640752a69c68c48589382c31907fb626e15fe400"
    sha256                               arm64_sonoma:  "d8fd69fa828324672d4ac2e867c9068771238889e753f804013d6904c1c7dfcb"
    sha256                               arm64_ventura: "3dc12615bcd5ca98d8c53d3fd8de6c338e8011543f11aedd86cace7a495ebda4"
    sha256                               sonoma:        "7b5d7ade938030549c5080e98883fb9bcf03d9ab5fe5de4ce738ba2cfc244054"
    sha256                               ventura:       "05f4ecd34b7d96a4d7faf3aac3cc976fb179d717bdd419a661d73da9306963f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa31b382b460cd452abcb082811fc6ed6773dc2b08260af36c27f1c89ca68d58"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    # Skip `firebase init` on self-hosted Linux as it has different behavior with nil exit status
    if !OS.linux? || ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
      assert_match "Failed to authenticate", shell_output("#{bin}firebase init", 1)
    end

    output = pipe_output("#{bin}firebase login:ci --interactive --no-localhost", "dummy-code")
    assert_match "Unable to authenticate", output
  end
end