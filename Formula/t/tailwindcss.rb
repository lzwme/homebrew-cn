class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:registry.npmjs.org@tailwindcsscli-cli-4.0.4.tgz"
  sha256 "b75edc09ae4e5b4e9b3d6817f31c083346a23089a80591b62e4ff9de2cb9e300"
  license "MIT"
  head "https:github.comtailwindlabstailwindcss.git", branch: "next"

  # There can be a notable gap between when a version is added to npm and the
  # GitHub release is created, so we check the "latest" release on GitHub
  # instead of the default `Npm` check for the `stable` URL.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_sequoia: "305aea1ec37a55c2833681a410e7ce5218cbd8ff45a9538cbd59230447ef14b6"
    sha256                               arm64_sonoma:  "ee848c629b5b22ec97ce2ae30c5c5ebdd6b7904ea780161ed9ccaaf1b046449a"
    sha256                               arm64_ventura: "a5f166c9d0c9277a3d9ad2a2ac1cd6154c11346a5e61b57e24c3e635667deb7e"
    sha256                               sonoma:        "17a16c0392a4e04666d4e948259affaacb096dc311449239926502c78147f5ee"
    sha256                               ventura:       "5b911567cf0e39d764b3cc1961c4cca8ad08f83af85dfa0580f7ddb6b3186dcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a29ae308b2b26cfdf64dbe1641aec35628623ef63921b0b3ca056ef2bc893abc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    (testpath"input.css").write("@tailwind base;")
    system bin"tailwindcss", "-i", "input.css", "-o", "output.css"
    assert_path_exists testpath"output.css"
  end
end