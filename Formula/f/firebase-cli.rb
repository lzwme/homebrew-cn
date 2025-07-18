class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.11.0.tgz"
  sha256 "2f500afc13f8035a7f748e49faa42c44643ca0706b21adbfc79118551093ebdf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6b6f7de909e6a7a0adbd9c3be214b24b067978264394bef8dda8af8dc776060"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6b6f7de909e6a7a0adbd9c3be214b24b067978264394bef8dda8af8dc776060"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6b6f7de909e6a7a0adbd9c3be214b24b067978264394bef8dda8af8dc776060"
    sha256 cellar: :any_skip_relocation, sonoma:        "4962ed856454242eb4abc7f327664d6f6ff741016397f237aade59a12cffe169"
    sha256 cellar: :any_skip_relocation, ventura:       "4962ed856454242eb4abc7f327664d6f6ff741016397f237aade59a12cffe169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "880449e8396ba8d9883fa65c2b91d00fcb5ca94f1544b1e0dc875f1b77ee7411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18dd9d257239dce4381aea37ff5196326cb63985a7ec37c063af8dbe232a474e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Skip `firebase init` on self-hosted Linux as it has different behavior with nil exit status
    if !OS.linux? || ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
      assert_match "Failed to authenticate", shell_output("#{bin}/firebase init", 1)
    end

    output = shell_output("#{bin}/firebase use dev 2>&1", 1)
    assert_match "Failed to authenticate, have you run \e[1mfirebase login\e[22m?", output
  end
end