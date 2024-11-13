class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.25.0.tgz"
  sha256 "2847161653eda6ca12e8a1950978dcd69c34bc809f1aed14150edec408899a27"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "0bbcdf8d4c2da676029356374e66870d1aac5037b304007e043d3be5f764cf89"
    sha256                               arm64_sonoma:  "69261252759141195793d21df1909e408c6ccd27168626cd887cc2c3ff45c9bf"
    sha256                               arm64_ventura: "84b03dbebaf85a682a25ecd68a810dc6e30d346fa83bed6633e2a2a787f3856a"
    sha256                               sonoma:        "f0f0480b8e19eeb394d404b78314da7ca1deb82296564334d25788592bb14660"
    sha256                               ventura:       "227720a9668113bbd864aaa327bbe342cb53e20a3a5faad766677cecac02b08f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7253b0d1eab8c2eeda8bdee758084705867a640518981d164e5b050ae8915b93"
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