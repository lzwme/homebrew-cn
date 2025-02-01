class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:registry.npmjs.orgtailwindcss-tailwindcss-4.0.2.tgz"
  sha256 "4636533065a1ac058611aebfde93ef16d8197b162447cf212e17468a07f5a93e"
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
    sha256                               arm64_sequoia: "5bf65671f1afd586eccf17327883bfa5cd74c5f0d85ad6f3b1d7b08a03cd6f08"
    sha256                               arm64_sonoma:  "dbcf8fbd257414979d4c810ac99afcb4422e095dfe285747076f2bf0f971ef53"
    sha256                               arm64_ventura: "bbf02255069862abffd913403a13e0b53ef964896834a0f20870e8df2cfdc6bb"
    sha256                               sonoma:        "1b77b59706b439287a0fbd18c66bf40fee5c1c8b99449cbd37112d30a866126a"
    sha256                               ventura:       "29e42290b9514fdbfab6cbda12f409e7e12ba2acae610cec265cb1229e32a032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37f4fd5fc54c8a438815a152f760c99d176c9aac95a6a288467d249edadf1d86"
  end

  depends_on "node"

  resource "tailwind-cli" do
    url "https:registry.npmjs.org@tailwindcsscli-cli-4.0.2.tgz"
    sha256 "1f0923f621c91729ae5469670c5fa3e34b184162a251369ffac0e77b60f9e4c6"
  end

  def install
    # install the dedicated tailwind-cli package
    resource("tailwind-cli").stage do
      system "npm", "install", *std_npm_args
    end

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    (testpath"input.css").write("@tailwind base;")
    system bin"tailwindcss", "-i", "input.css", "-o", "output.css"
    assert_path_exists testpath"output.css"
  end
end