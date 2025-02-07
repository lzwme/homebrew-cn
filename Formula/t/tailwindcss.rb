class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:registry.npmjs.orgtailwindcss-tailwindcss-4.0.4.tgz"
  sha256 "e609ad18ca3b6a033879192f214d1c75394c1bbd7eb662aee5df5ddee0a8ee72"
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
    sha256                               arm64_sequoia: "749dcb998d189dcb5ecdcb35fb6530ebbce34fd12aef9cd588a737be0583a42f"
    sha256                               arm64_sonoma:  "8983d61ca478494f9016d8db212d6f30e5de50ed3154664ab879909ceb25d712"
    sha256                               arm64_ventura: "97fc89e2d35fdf9f10305f984950aad132d5d4dcb86e736daef9ffef3588777a"
    sha256                               sonoma:        "bcaf49e8ec6ac250ceff58097b1cbf3c54b57587beab75ce89e7ee583d94bfca"
    sha256                               ventura:       "722d61c573ff8538d9b5ddcc92b864f9def65d28d133a5098a94c9558d4ca3f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "643b9a75a0b58b367b37d17fbde0d2b4180b065405adb9605b2da0ae68fa31a1"
  end

  depends_on "node"

  resource "tailwind-cli" do
    url "https:registry.npmjs.org@tailwindcsscli-cli-4.0.4.tgz"
    sha256 "b75edc09ae4e5b4e9b3d6817f31c083346a23089a80591b62e4ff9de2cb9e300"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "tailwind-cli resource needs to be updated" if version != resource("tailwind-cli").version

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